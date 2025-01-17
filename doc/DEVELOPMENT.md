# German transcripts

with speaker classification

https://github.com/Softcatala/whisper-ctranslate2

See installation of dependencies from here: https://github.com/Softcatala/whisper-ctranslate2 

* Install pyannote.audio with "pip install pyannote.audio" (https://github.com/pyannote/pyannote-audio)
* Accept pyannote/segmentation-3.0 user conditions (https://huggingface.co/pyannote/segmentation-3.0)
* Accept pyannote/speaker-diarization-3.1 user conditions (https://huggingface.co/pyannote/speaker-diarization-3.1)
* Create access token at https://hf.co/settings/tokens

```code

whisper-ctranslate2 --model large-v2 --output_dir output --device cpu --language de --hf_token hf_qwertzuiopasdfghjkkll   filename.mp3|avi|mp4|...  

```

Should work without GPU

Transcript takes twice the time of the audio (1st pass: speaker classification, 2nd pass: speech recognition)

- identify speakers and replace with their names

merge lines with same speakers into one line:

perl merge_speakers.pl transcript_with_speaker_names.txt transkript_merged_speaker_names_noprompt.txt

generate protocol from every line

perl summarize_per_line.pl transkript_merged_speaker_names_noprompt.txt protocol_per_line_variants.txt

# Summarize transcript

## llama

fetch llama model(s) in packed format:

https://github.com/akx/ollama-dl 

    set up a Python virtualenv
    
    pip install -e .
    
    python3 ollama_dl.py llama3.1:8b (or any other model)

alternative: check this link how to generate gguf files https://github.com/ggerganov/llama.cpp/discussions/2948

    pip install huggingface_hub
    
    write script "download.py":

```code
from huggingface_hub import snapshot_download
model_id="togethercomputer/LLaMA-2-7B-32K"
snapshot_download(repo_id=model_id, local_dir="vicuna-hf",
                  local_dir_use_symlinks=False, revision="main")
```    
  
    python3 download.py
    
    install llama.cpp python deps: 
    
    pip install -r llama.cpp/requirements.txt
    
    run conversion script:
    
    python convert_hf_to_gguf.py ../tmp10/togethercomputer_LLaMA-2-7B-32K/ --outfile togethercomputer_LLaMA-2-7B-32K.gguf --outtype q8_0 
    
    (check help for other quantizations)
    
    
download & build llama.cpp:

https://github.com/ggerganov/llama.cpp

    [options for acceleration] make (-j)
    
    example: GGML_CUDA=1 CUDA_DOCKER_ARCH=sm_61 make -j
    
    
```code

./llama-cli -m ../ollama-dl/library-llama3.1/model-8eeb52dfb3bb.gguf --file transcript_with_prompt_at_end.txt

```

Prompt at file end:

```code

Erstelle mir eine protokollarische Zusammenfassung dieser Unterhaltung. Benutze die Worte in eckigen Klammern zur Benennung der jeweiligen Sprecher.

```

Prompt enclosing transcript (1):

```code

Erstelle ein detailliertes Protokoll basierend auf dem folgenden Transkript der Unterhaltung:
"
TRANSCRIPT
"
Achte darauf, die wichtigsten Themen, Entscheidungen und Fragen zu erfassen. Benutze die Worte in eckigen Klammern zur Benennung der jeweiligen Sprecher, und fasse ihre Beiträge klar und präzise zusammen.

```

Prompt enclosing transcript (2):

```code

Erstelle ein detailliertes Protokoll basierend auf dem folgenden Transkript der Unterhaltung:
"
TRANSCRIPT
"
Die Worte in eckigen Klammern kennzeichnen den jeweiligen Sprecher. Fasse die Wortmeldung jedes einzelnen Sprechers zusammen und kennzeichne dabei, von welchem Sprecher sie stammt.

```


## reasonable models

ollama: 
    library-llama3.1-8b
    library-mistral-7b-instruct
    
    

