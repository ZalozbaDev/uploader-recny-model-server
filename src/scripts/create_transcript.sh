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

# TODO: caluculate duration of the file calculation
echo "0|Processing $SOURCEFILE" >> $PROGRESS
sleep 5
DURATION=12345 # in seconds
(echo $DURATION && cat $PROGRESS) > progress.tmp && mv progress.tmp $PROGRESS && rm progress.tmp # Set duration to the first line of the file

echo "10|Calculating Audio length" >> $PROGRESS
sleep 1
echo "20|Do abc" >> $PROGRESS
sleep 1
echo "60|And do that" >> $PROGRESS
sleep 1
echo "100|Cool" >> $PROGRESS
touch ${SOURCEFILE}.${OUTFORMAT}
