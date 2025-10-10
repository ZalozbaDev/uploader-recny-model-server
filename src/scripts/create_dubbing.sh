#!/bin/bash

FOLDERNAME=$1
SOURCEFILE=$2
PROGRESS=$3
SRTAVAILABLE=$4
SRTFILE=$5 


echo "Rjadowak=$FOLDERNAME"
echo "Dataja=$SOURCEFILE"
echo "Postup=$PROGRESS"
echo "MaSRT=$SRTAVAILABLE"
echo "SRTFILE=$SRTFILE"

OUTFILENAMENOEXT="${SOURCEFILE%.*}"
CWD=$(pwd)

echo "SOTRA_URL=$SOTRA_URL"
echo "HF_TOKEN=$HF_TOKEN"

touch $PROGRESS

echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS

if [ "$SRTAVAILABLE" = "true" ]; then
	$(dirname $0)/dubbing.sh ${CWD}/${SOURCEFILE} ${CWD}/${FOLDERNAME}/dubbing/ ${CWD}/${SRTFILE} 

	# move results to expected places
	mv $FOLDERNAME/dubbing/dubbed_video_hsb.mp4 ${OUTFILENAMENOEXT}.mp4
	mv $FOLDERNAME/dubbing/hsb.srt              ${OUTFILENAMENOEXT}.srt
	
	# only video and translated subs are available (original subs were provided)
	echo "100|Dubbing hotowe|0|1|1|0" >> $PROGRESS
else
	$(dirname $0)/dubbing.sh ${CWD}/${SOURCEFILE} ${CWD}/${FOLDERNAME}/dubbing/

	# move results to expected places
	mv $FOLDERNAME/dubbing/dubbed_video_hsb.mp4 ${OUTFILENAMENOEXT}.mp4
	mv $FOLDERNAME/dubbing/hsb.srt              ${OUTFILENAMENOEXT}.srt
	mv $FOLDERNAME/dubbing/deu.srt              ${OUTFILENAMENOEXT}.de.srt
	
	# video and both subs (original, translated) are available
	echo "100|Dubbing hotowe|0|1|1|1" >> $PROGRESS
fi

