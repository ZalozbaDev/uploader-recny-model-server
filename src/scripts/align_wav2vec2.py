from transformers import AutoProcessor, Wav2Vec2CTCTokenizer, Wav2Vec2BertForCTC
import librosa
import torch
import numpy as np
import ctc_segmentation
import soundfile as sf
import os
import re
import sys

model_name = "Korla/Wav2Vec2BertForCTC-hsb"
# device = "mps"
device = "cpu"

input_audio = sys.argv[1]
input_text = sys.argv[2]
output_srt = sys.argv[3]

# add to end of subtitle to catch last part of utterance
subtitle_overlap_end_seconds = 0.3

processor = AutoProcessor.from_pretrained(model_name)
tokenizer = Wav2Vec2CTCTokenizer.from_pretrained(model_name)
model = Wav2Vec2BertForCTC.from_pretrained(model_name).to(device)

# load audio
wav, sr = librosa.load(input_audio, sr=None)
wav16 = librosa.resample(wav, orig_sr=sr, target_sr=16000)

# read text
with open(input_text) as f:
    txt = f.read()
    
# clean transcripts and merge onto one line
transcripts = txt.replace("\n", " ").replace("- ", "").replace(" ...", ".")
# look for sentences-like chunks in the line and split
matches = re.findall(r'.*?[.?](?=\s|$|["»«“”„])', transcripts, flags=re.DOTALL)
# append possible leftover that was not sentence-like 
consumed = "".join(matches)
remainder = transcripts[len(consumed):].strip()
if remainder:
    matches.append(remainder)
# finally trim lines 
transcripts = [m.strip() for m in matches if m.strip()]
transcripts = [t for t in transcripts if t]

# Split long transcripts by '!' in the middle
new_transcripts = []
for t in transcripts:
    if len(t) > 180 and "!" in t:
        excl_indices = [i for i, c in enumerate(t) if c == "!"]
        # Find the '!' closest to the middle
        mid = len(t) // 2
        split_idx = min(excl_indices, key=lambda x: abs(x - mid))
        left = t[:split_idx+1].strip()
        right = t[split_idx+1:].strip()
        if left:
            new_transcripts.append(left)
        if right:
            new_transcripts.append(right)
    else:
        new_transcripts.append(t)
transcripts_orig = new_transcripts

# finally convert to lower case for CTC
transcripts = [t.lower() for t in transcripts_orig if t]

print(transcripts)

# enable for alignment on word (not sentence) level
alignment_on_word_level = 0
if alignment_on_word_level == 1:
    words = []
    for sentence in transcripts:
        cleaned_words = re.findall(r'\b\w+\b', sentence)
        words.extend(cleaned_words)
        transcripts = words

    print(transcripts)

# run chunked wav2vec2 processing of whole audio
chunk_length_s = 10
chunk_size = chunk_length_s * 16000
batch_size = 4

logits_list = []
chunks = []

for start in range(0, wav16.shape[0], chunk_size):
    end = min(start + chunk_size, wav16.shape[0])
    chunk = wav16[start:end]
    chunks.append(chunk)
    if len(chunks) == batch_size or end == wav16.shape[0]:
        inputs = processor(chunks, sampling_rate=16000, return_tensors="pt", padding=True)
        with torch.no_grad():
            outputs = model(**inputs.to(device))
            logits = outputs.logits  # [batch, time, vocab]
            logits_list.extend([l.unsqueeze(0) for l in logits])  # keep [1, time, vocab] per chunk
        chunks = []

logits_all = torch.cat(logits_list, dim=1)
print(logits_all.shape)

print("wav2vec2 processing done")

# ?
probs = logits_all.softmax(dim=-1)
probs = probs.squeeze(0)

# set up tokenizer
vocab = tokenizer.get_vocab()
inv_vocab = {v:k for k,v in vocab.items()}
unk_id = vocab["[UNK]"]

# tokenize transcripts
tokens = []
for transcript in transcripts:
    assert len(transcript) > 0
    tok_ids = tokenizer(transcript.replace("\n"," ").lower())['input_ids']
    tok_ids = np.array(tok_ids,dtype=np.int64)
    tokens.append(tok_ids[tok_ids != unk_id])

# set up CTC 
char_list = [inv_vocab[i] for i in range(len(inv_vocab))]
config = ctc_segmentation.CtcSegmentationParameters(char_list=char_list)
# defaults
#    index_duration = 0.025
#    score_min_mean_over_L = 30

# apply always
config.index_duration = 0.04
# apply for sentence level confidence (word level confidence works with default)
if alignment_on_word_level == 0:
    config.score_min_mean_over_L = 400

# Align
print("Start alignment")

ground_truth_mat, utt_begin_indices = ctc_segmentation.prepare_token_list(config, tokens)

timings, char_probs, state_list = ctc_segmentation.ctc_segmentation(config, probs.to("cpu").numpy(), ground_truth_mat)
segments = ctc_segmentation.determine_utterance_segments(config, utt_begin_indices, char_probs, timings, transcripts)

# write result
import glob

i = 1
idx = 33
# wav_files = glob.glob("data/complete/wavs/*.wav")
# if wav_files:
#     max_idx = max([int(os.path.splitext(os.path.basename(f))[0]) for f in wav_files if os.path.splitext(os.path.basename(f))[0].isdigit()])
#     i = max_idx + 1
# else:
#     i = 1

# with open("data/complete/1/metadata.csv") as f:
#     metadata = f.read().strip()

metadata = ""

#for segment in [{"text" : t, "start" : p[0], "end" : p[1], "conf" : p[2]} for t,p in zip(transcripts, segments)]:
#    # print(segment)
#    print(f"{segment['text']} ({segment['start']:.2f} - {segment['end']:.2f}) [{segment['conf']:.2f}]")
#    metadata += f"\n{i}.wav|{segment['text']}"
#    sf.write(f"../kupa_out/{idx}_{i}.wav", wav[int(segment['start'] * sr):int((segment['end'] + 0.3) * sr)], sr)
#    i += 1

#with open(f"../kupa_out/{idx}_metadata.csv", "w") as f:
#    f.write(metadata)

import pysrt

def float_to_srt_time(seconds):
    """Convert float seconds to pysrt.SubRipTime"""
    millis = int(round(seconds * 1000))
    hours = millis // 3600000
    minutes = (millis % 3600000) // 60000
    seconds = (millis % 60000) // 1000
    milliseconds = millis % 1000
    return pysrt.SubRipTime(hours=hours, minutes=minutes, seconds=seconds, milliseconds=milliseconds)

def find_orig_transcript(segment_text):
    try:
        idx = transcripts.index(segment_text)
        return transcripts_orig[idx]
    except ValueError:
        print(f"Could not find transcript -{segment_text}- in list.")
        sys.exit(f"Error: segment '{segment}' not found in transcripts.")   

i = 1
subs = pysrt.SubRipFile()
last_segment_endtime = 0.0
for segment in [{"text" : t, "start" : p[0], "end" : p[1], "conf" : p[2]} for t,p in zip(transcripts, segments)]:
    sub = pysrt.SubRipItem()
    sub.index = i
    confidence = segment['conf']
    
    orig_text = find_orig_transcript(segment['text'])
    
    # might annotate poor alignment confidence in the future
    if confidence >= 0.5:
        print(f"OK: Subtitle {i} confidence {confidence:.2f}.")
        sub.text = orig_text
    else:
        print(f">>>> WARNING: Subtitle {i} low confidence {confidence:.2f}.")
        # sub.text = f"{segment['conf']:.2f} : " + segment['text']
        sub.text = orig_text
    
    # assign segment start and end, apply overlap at end and remove overlap from start
    this_start = segment['start']
    if this_start < last_segment_endtime:
        this_start = last_segment_endtime
    
    # assign time values
    sub.start = float_to_srt_time(this_start)
    # remember adjusted end time   
    last_segment_endtime = segment['end'] + subtitle_overlap_end_seconds
    sub.end = float_to_srt_time(last_segment_endtime)
    subs.append(sub)
    
    i += 1

subs.save(output_srt, encoding='utf-8')
print(f"SRT file saved to '{output_srt}'")
    
