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

touch $PROGRESS

echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS

if [ "$SRTAVAILABLE" = "true" ]; then
	$(dirname $0)/dubbing.sh $SOURCEFILE $FOLDERNAME $SRTFILE 
else
	$(dirname $0)/dubbing.sh $SOURCEFILE $FOLDERNAME
fi

echo "100|Dubbing hotowe|0|0|1|0" >> $PROGRESS
