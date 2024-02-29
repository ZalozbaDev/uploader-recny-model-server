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


echo "Dataja=$SOURCEFILE"
echo "Postup=$PROGRESS"
echo "Rjadowak=$FOLDERNAME"
echo "Model=$MODEL"
echo "Format=$OUTFORMAT"

touch $PROGRESS

case $MODEL in

	FHG)
		echo "100|Tuta warianta hišće njeje přistupna!" >> $PROGRESS
		;;
	
	HF)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe ($DURATION)" >> $PROGRESS
		if [ "$OUTFORMAT" = "SRT" ]; then
			/whisper.cpp/main -m /whisper/hsb/whisper_small/ggml-model.bin --output-txt -f $SOURCEFILE.wav.resample.wav
			mv $SOURCEFILE.wav.resample.wav.srt $SOURCEFILE.srt
			echo "100|Podtitle hotowe" >> $PROGRESS
		else
			/whisper.cpp/main -m /whisper/hsb/whisper_small/ggml-model.bin --output-srt -f $SOURCEFILE.wav.resample.wav
			mv $SOURCEFILE.wav.resample.wav.txt $SOURCEFILE.txt
			echo "100|Tekst hotowe" >> $PROGRESS
		fi
		;;
	
	FB)
		echo "100|Tuta warianta hišće njeje přistupna!" >> $PROGRESS
		;;
	
	BOZA_MSA)
		if [ "$OUTFORMAT" = "SRT" ]; then
			echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
			ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
			DURATION=$(soxi -D $SOURCEFILE.wav)
			echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
			cat $PROGRESS >> $PROGRESS.tmp
			mv $PROGRESS.tmp $PROGRESS
			sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
			echo "20|Resampling hotowe ($DURATION)" >> $PROGRESS
			LD_LIBRARY_PATH=/proprietary /proprietary/testrec /proprietary/merged_47_adp.cfg $SOURCEFILE.wav.resample.wav | tee $SOURCEFILE.wav.resample.wav.rec.log
			echo "80|Spóznawanje hotowe" >> $PROGRESS
			python3 $(dirname $0)/log2srt.py $SOURCEFILE.wav.resample.wav.rec.log
			mv uploads/${FOLDERNAME}/*.srt ${SOURCEFILE}.${OUTFORMAT}
			echo "100|Podtitle hotowe" >> $PROGRESS
			# echo "-1"  >> $PROGRESS
			echo "----> HOTOWE <----"
		else
			echo "100|Tuta warianta hišće njeje přistupna!" >> $PROGRESS
		fi
		;;
		
	DEVEL)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		sleep 1
		DURATION="175"
		echo $DURATION > $PROGRESS.tmp
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sleep 1
		echo "20|Resampling hotowe ($DURATION)" >> $PROGRESS
		sleep 5
		echo "80|Spóznawanje hotowe" >> $PROGRESS
		sleep 1
		touch ${SOURCEFILE}.${OUTFORMAT}
		echo "100|Podtitle hotowe" >> $PROGRESS
		# echo "-1"  >> $PROGRESS
		echo "----> HOTOWE <----"
		;;
		
	*)
		echo "100|Tuta warianta hišće njeje přistupna!" >> $PROGRESS
		;;
	
esac
