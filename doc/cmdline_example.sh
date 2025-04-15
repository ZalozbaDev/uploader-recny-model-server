docker run --privileged --mount type=bind,source=$(pwd)/model,target=/model/ \
--mount type=bind,source=$(pwd)/input,target=/input/ --mount type=bind,source=$(pwd)/output,target=/output/ \
--mount type=bind,source=$(pwd)/cache,target=/root/.cache/ -it ctranslate_diarization_cuda  \
/bin/bash -c 'cd whisper_ctranslate && source bin/activate && LD_LIBRARY_PATH=/whisper_ctranslate/oldlibs_cudnn:/whisper_ctranslate/oldlibs_cublas whisper-ctranslate2 --model_directory /model/ct2-Korla/ --local_files_only true --output_dir /output/__CHANGEME__/ --device cuda --hf_token hf___CHANGEME__ --speaker_num 20 /input/*.mp4'


# example for german transcripts
# docker run --privileged --mount type=bind,source=$(pwd)/model,target=/model/ --mount type=bind,source=$(pwd)/input,target=/input/ --mount type=bind,source=$(pwd)/output,target=/output/ --mount type=bind,source=$(pwd)/cache,target=/root/.cache/ -it ctranslate_diarization_cuda  /bin/bash -c 'cd whisper_ctranslate && source bin/activate && LD_LIBRARY_PATH=/whisper_ctranslate/oldlibs_cudnn:/whisper_ctranslate/oldlibs_cublas whisper-ctranslate2 --model large-v3-turbo --language=de  --output_dir /output/komisija/ --device cuda --hf_token hf_XYXYXYXYXYXYXYX  --speaker_num 20 /input/*.wav '

