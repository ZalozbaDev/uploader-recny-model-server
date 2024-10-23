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

