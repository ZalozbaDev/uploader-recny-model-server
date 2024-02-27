#!/bin/bash

if [ "$#" -ne 5 ]; then
	echo "need to run this script with the following arguments:"
	echo "./create_transcript.sh FOLDER SOURCEFILENAME LANGUAGEMODEL OUTPUTFORMAT PROGRESSFILE"
	echo "Example:"
	echo "./create_transcript.sh 672536cdbea8737853 video.mp4 whisper srt progress.txt"
	exit -1
fi

FOLDERNAME=$1
SOURCEFILE=$2
MODEL=$3
OUTFORMAT=$4
PROGRESS=$5


echo $SOURCEFILE
echo $PROGRESS
echo $FOLDERNAME

touch $PROGRESS
echo "Processing $SOURCEFILE" >> $PROGRESS
sleep 1
echo "Audio length = XXXXXX" >> $PROGRESS
sleep 1
echo "20" >> $PROGRESS
sleep 10
echo "60" >> $PROGRESS
sleep 1
echo "100" >> $PROGRESS
sleep 1
touch ${SOURCEFILE}.${OUTFORMAT}
echo "-1"  >> $PROGRESS
echo "----> HOTOWE <----"

