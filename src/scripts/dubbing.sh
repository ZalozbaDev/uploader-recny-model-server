#!/bin/bash

# OPENDUBBING_DIR=/open-dubbing
OPENDUBBING_DIR=/opt/venv/open-dubbing

# OPENDUBBING_DEVICE=cpu
OPENDUBBING_DEVICE=cuda


pushd ${OPENDUBBING_DIR}
source bin/activate

echo "open-dubbing called with args $1 , $2 , $3"

FILENAME=$1
OUTDIR=$2

echo "SOTRA_URL=$SOTRA_URL"
echo "HF_TOKEN=$HF_TOKEN"

export TORCH_FORCE_WEIGHTS_ONLY_LOAD=0

if [ "$#" -eq 3 ]; then
	echo "Have SRT"
	SUBSFILE=$3
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./lib/python3.12/site-packages/nvidia/cudnn/lib/ \
	open-dubbing --input_file $FILENAME --source_language deu --target_language hsb \
	--hugging_face_token $HF_TOKEN --output_directory $OUTDIR \
	--translator sotra --apertium_server $SOTRA_URL \
	--tts bamborak --tts_api_server https://bamborakapi.mudrowak.de/api/tts/ \
	--dubbed_subtitles --original_subtitles --log_level DEBUG --input_srt $SUBSFILE \
	--device ${OPENDUBBING_DEVICE}
else
	echo "do not have SRT"
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./lib/python3.12/site-packages/nvidia/cudnn/lib/ \
	open-dubbing --input_file $FILENAME --source_language deu --target_language hsb \
	--hugging_face_token $HF_TOKEN --output_directory $OUTDIR \
	--translator sotra --apertium_server $SOTRA_URL \
	--tts bamborak --tts_api_server https://bamborakapi.mudrowak.de/api/tts/ \
	--dubbed_subtitles --original_subtitles --log_level DEBUG \
	--device ${OPENDUBBING_DEVICE}
fi

echo "open-dubbing DONE"

popd
