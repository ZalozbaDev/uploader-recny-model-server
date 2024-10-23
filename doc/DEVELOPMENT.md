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

# Summarize transcript

## llama

fetch llama model(s) in packed format:

https://github.com/akx/ollama-dl 

    set up a Python virtualenv
    
    pip install -e .
    
    python3 ollama_dl.py llama3.2:1b (or any other model)
    
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
