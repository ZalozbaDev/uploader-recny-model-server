#!/bin/bash

FOLDERNAME=$1
SOURCEFILE=$2
TEXTFILE=$3
MODEL=$4
PROGRESS=$5
TRANSLATE=$6 


echo "Rjadowak=$FOLDERNAME"
echo "Dataja=$SOURCEFILE"
echo "Text=$TEXTFILE"
echo "Model=$MODEL"
echo "Postup=$PROGRESS"
echo "Translate=$TRANSLATE"

touch $PROGRESS

case $MODEL in

	WAV2VEC2)
		$(dirname $0)/forcealign.sh $SOURCEFILE $TEXTFILE $SOURCEFILE.srt
		
		if [ "$TRANSLATE" = "true" ]; then
			# run the .srt translation
			$(dirname $0)/translate_srt.sh ${SOURCEFILE}.srt ${SOURCEFILE}_de.srt hsb de "http://sotra-fairseq:3000/translate"
			ln -s $(basename ${SOURCEFILE}_de.srt) $(echo "${SOURCEFILE%.*}"_de.srt)
			
			echo "100|Podtitle hotowe|0|1|1" >> $PROGRESS
		else
			# nothing more to do
			echo "100|Podtitle hotowe|0|1|0" >> $PROGRESS
		fi
		;;
	
	DEVEL)
		echo "0|Wobdźěłam $SOURCEFILE z $TEXTFILE" >> $PROGRESS
		sleep 1
		DURATION="175"
		echo $DURATION > $PROGRESS.tmp
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		cp $SOURCEFILE $SOURCEFILE.wav
		cp $SOURCEFILE.wav $SOURCEFILE.wav.resample.wav
		cp $SOURCEFILE $SOURCEFILE.wav.resample.wav.rec.log
		sleep 1
		echo "20|Resampling hotowe ($DURATION)" >> $PROGRESS
		
		cp $SOURCEFILE.wav.resample.wav $SOURCEFILE.wav.resample.wav.rec.log
		cp $SOURCEFILE.wav.resample.wav $SOURCEFILE.wav.resample.wav.rec.log
		sleep 5
		echo "80|Spóznawanje hotowe" >> $PROGRESS
		
		sleep 1
		cp $SOURCEFILE.wav.resample.wav.rec.log ${SOURCEFILE}.txt
		ln -s $(basename $SOURCEFILE.txt) $(echo "${SOURCEFILE%.*}".srt)
		ln -s $(basename $SOURCEFILE.txt) $(echo "${SOURCEFILE%.*}"_de.srt)
		echo "100|Podtitle hotowe|0|1|1" >> $PROGRESS
		echo "----> HOTOWE <----"
		;;

	*)
		echo "100|Tuta warianta hišće njeje přistupna!" >> $PROGRESS
		;;
	
esac
