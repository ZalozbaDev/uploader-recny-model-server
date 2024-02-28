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
ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
echo "Audio length = XXXXXX" >> $PROGRESS
sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
echo "20" >> $PROGRESS
LD_LIBRARY_PATH=/proprietary /proprietary/testrec /proprietary/merged_47_adp.cfg $SOURCEFILE.wav.resample.wav | tee $SOURCEFILE.wav.resample.wav.rec.log
echo "60" >> $PROGRESS
python3 $(dirname $0)/log2srt.py $SOURCEFILE.wav.resample.wav.rec.log
echo "80" >> $PROGRESS
mv uploads/${FOLDERNAME}/*.srt ${SOURCEFILE}.${OUTFORMAT}
echo "100" >> $PROGRESS
sleep 1
echo "-1"  >> $PROGRESS
echo "----> HOTOWE <----"

