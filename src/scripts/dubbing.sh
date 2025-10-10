#!/bin/bash

pushd /open-dubbing
source bin/activate

echo "open-dubbing called with args $1 , $2 , $3"

FILENAME=$1
OUTDIR=$2

echo "SOTRA_URL=$SOTRA_URL"
echo "HF_TOKEN=$HF_TOKEN"

if [ "$#" -eq 3 ]; then
	echo "Have SRT"
	SUBSFILE=$3
	open-dubbing --input_file $FILENAME --source_language deu --target_language hsb \
	--hugging_face_token $HF_TOKEN --output_directory $OUTDIR \
	--translator sotra --apertium_server $SOTRA_URL \
	--tts bamborak --tts_api_server https://bamborakapi.mudrowak.de/api/tts/ \
	--dubbed_subtitles --original_subtitles --log_level DEBUG --input_srt $SUBSFILE \
	--device cpu
else
	echo "do not have SRT"
	open-dubbing --input_file $FILENAME --source_language deu --target_language hsb \
	--hugging_face_token $HF_TOKEN --output_directory $OUTDIR \
	--translator sotra --apertium_server $SOTRA_URL \
	--tts bamborak --tts_api_server https://bamborakapi.mudrowak.de/api/tts/ \
	--dubbed_subtitles --original_subtitles --log_level DEBUG \
	--device cpu
fi

echo "open-dubbing DONE"

popd
