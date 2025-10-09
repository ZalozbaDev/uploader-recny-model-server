#!/bin/bash

FOLDERNAME=$1
SOURCEFILE=$2
MODEL=$3
OUTFORMAT=srt
PROGRESS=$4
TRANSLATE=$5 
DIARIZATION=$6 
VAD=$7


echo "Dataja=$SOURCEFILE"
echo "Postup=$PROGRESS"
echo "Rjadowak=$FOLDERNAME"
echo "Model=$MODEL"
echo "Format=$OUTFORMAT (ignored)"
echo "Translate=$TRANSLATE"
echo "DiarizeSpeakers=$DIARIZATION"
echo "VAD=$VAD"
echo "SOTRA_URL=$SOTRA_URL"

OUTFILENAMENOEXT="${SOURCEFILE%.*}"
CWD=$(pwd)
echo "Output filename w/o ext: $OUTFILENAMENOEXT"
echo "CWD: $CWD"

echo "SOTRA_URL=$SOTRA_URL"

echo "HF_TOKEN=$HF_TOKEN"

touch $PROGRESS

# list all currently used models here

RECIKTS_MODEL_BOZA_MSA=misa_2024_08_02.cfg
WHISPER_MODEL_HSB=/whisper/hsb/whisper_small/ggml-model.bin
WHISPER_MODEL_HSB_BIG=/whisper/Korla/whisper_large_v3_turbo_hsb/ggml-model.bin
WHISPER_MODEL_GERMAN=large-v2

case $MODEL in

	HFHSB)
		# video --> audio
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		
		# this model does not diarize
		
		# VAD on
		if [ "$VAD" = "true" ]; then
			
			sox $SOURCEFILE.wav -r 48000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
			echo "20|Resampling hotowe" >> $PROGRESS
			LD_LIBRARY_PATH=/. /whisper_main /whisper/hsb/whisper_small/ggml-model.bin $SOURCEFILE.wav.resample.wav ./uploads/${FOLDERNAME} > ./uploads/${FOLDERNAME}/log.txt 2>&1
			
			mv uploads/${FOLDERNAME}/subtitles.srt ${OUTFILENAMENOEXT}.srt
			mv uploads/${FOLDERNAME}/transcript.txt ${OUTFILENAMENOEXT}.txt
			
			if [ "$TRANSLATE" = "true" ]; then
				# run the .srt translation
				$(dirname $0)/translate_srt.sh ${CWD}/${OUTFILENAMENOEXT}.srt ${CWD}/${OUTFILENAMENOEXT}.de.srt hsb de $SOTRA_URL
				
				echo "100|Podtitle hotowe|1|1|0|1" >> $PROGRESS
			else
				# nothing more to do
				echo "100|Podtitle hotowe|1|1|0|0" >> $PROGRESS
			fi
			
		# VAD off, only create transcript
		else
			
			sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
			echo "20|Resampling hotowe" >> $PROGRESS
			
			/whisper.cpp/build/bin/whisper-cli -m /whisper/hsb/whisper_small/ggml-model.bin --output-txt -f $SOURCEFILE.wav.resample.wav
			mv $SOURCEFILE.wav.resample.wav.txt ${OUTFILENAMENOEXT}.txt
			echo "100|Transkript hotowe|1|0|0|0" >> $PROGRESS
			
			# transcript will not be translated
		fi
		;;
	
	BOZA_MSA)
		# video --> audio
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		
		# this model does not diarize
		
		# VAD on
		if [ "$VAD" = "true" ]; then
			
			sox $SOURCEFILE.wav -r 48000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
			echo "20|Resampling hotowe" >> $PROGRESS
			LD_LIBRARY_PATH=/proprietary /recikts_main /proprietary/$RECIKTS_MODEL_BOZA_MSA $SOURCEFILE.wav.resample.wav ./uploads/${FOLDERNAME} > ./uploads/${FOLDERNAME}/log.txt 2>&1
			echo "80|Spóznawanje hotowe" >> $PROGRESS
			
			mv uploads/${FOLDERNAME}/subtitles.srt ${OUTFILENAMENOEXT}.srt
			mv uploads/${FOLDERNAME}/transcript.txt ${OUTFILENAMENOEXT}.txt
			
			if [ "$TRANSLATE" = "true" ]; then
				# run the .srt translation
				$(dirname $0)/translate_srt.sh ${CWD}/${OUTFILENAMENOEXT}.srt ${CWD}/${OUTFILENAMENOEXT}.de.srt hsb de $SOTRA_URL
				
				echo "100|Podtitle hotowe|1|1|0|1" >> $PROGRESS
			else
				# nothing more to do
				echo "100|Podtitle hotowe|1|1|0|0" >> $PROGRESS
			fi
			
			
		# VAD off
		else
			
			sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
			echo "20|Resampling hotowe" >> $PROGRESS
			LD_LIBRARY_PATH=/proprietary /proprietary/testrec /proprietary/$RECIKTS_MODEL_BOZA_MSA $SOURCEFILE.wav.resample.wav | tee $SOURCEFILE.wav.resample.wav.rec.log
			echo "80|Spóznawanje hotowe" >> $PROGRESS
			
			python3 $(dirname $0)/log2srt.py $SOURCEFILE.wav.resample.wav.rec.log
			mv uploads/${FOLDERNAME}/*.srt ${OUTFILENAMENOEXT}.srt

			python3 $(dirname $0)/log2txt.py $SOURCEFILE.wav.resample.wav.rec.log
			mv uploads/${FOLDERNAME}/*.rawtxt ${OUTFILENAMENOEXT}.txt
			
			if [ "$TRANSLATE" = "true" ]; then
				# run the .srt translation
				$(dirname $0)/translate_srt.sh ${CWD}/${OUTFILENAMENOEXT}.srt ${CWD}/${OUTFILENAMENOEXT}.de.srt hsb de $SOTRA_URL
				
				echo "100|Podtitle hotowe|1|1|0|1" >> $PROGRESS
			else
				# nothing more to do
				echo "100|Podtitle hotowe|1|1|0|0" >> $PROGRESS
			fi
			
			
		fi
		;;
		
	GERMAN)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 48000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe" >> $PROGRESS
		
		pushd /ctranslate2
		source bin/activate
		
		if [ "$DIARIZATION" -gt 0 ]; then
			# with speaker diarization
			whisper-ctranslate2 --model $WHISPER_MODEL_GERMAN --output_dir /uploader-recny-model-server/uploads/${FOLDERNAME}/ --device cpu --hf_token $HF_TOKEN --language de /uploader-recny-model-server/$SOURCEFILE.wav.resample.wav > /uploader-recny-model-server/uploads/${FOLDERNAME}/log.log 2>&1
		else
			# no speaker diarization
			whisper-ctranslate2 --model $WHISPER_MODEL_GERMAN --output_dir /uploader-recny-model-server/uploads/${FOLDERNAME}/ --device cpu --language de /uploader-recny-model-server/$SOURCEFILE.wav.resample.wav > /uploader-recny-model-server/uploads/${FOLDERNAME}/log.log 2>&1
		fi
		popd

		ls -l /uploader-recny-model-server/uploads/${FOLDERNAME}/
		
		# TBD which filename?
		# mv ${SOURCEFILE%.*}*.txt $(echo "${SOURCEFILE%.*}".txt)
		mv $SOURCEFILE.wav.resample.wav ${OUTFILENAMENOEXT}.txt
		echo "100|Transkript hotowe|1|0|0|0" >> $PROGRESS
		;;
		
	DEVEL)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
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
		cp $SOURCEFILE.wav.resample.wav.rec.log ${OUTFILENAMENOEXT}.txt
		echo "100|Podtitle hotowe|1|0|0|0" >> $PROGRESS
		;;

	FB)
		#### currently unused ###############
		if [ "$OUTFORMAT" = "text" ]; then
			echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
			ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
			DURATION=$(soxi -D $SOURCEFILE.wav)
			echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
			cat $PROGRESS >> $PROGRESS.tmp
			mv $PROGRESS.tmp $PROGRESS
			sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
			echo "20|Resampling hotowe" >> $PROGRESS
			echo "test test test" > $SOURCEFILE.trl.resample.trl
			export USER=$FOLDERNAME
			pushd /fairseq
			source bin/activate
			python /fairseq/examples/mms/asr/infer/mms_infer.py --model /fairseqdata/mms1b_all.pt  --lang hsb --audio /uploader-recny-model-server/$SOURCEFILE.wav.resample.wav --format letter > /uploader-recny-model-server/$SOURCEFILE.log
			popd
			echo "80|Spóznawanje hotowe" >> $PROGRESS
			mv $SOURCEFILE.log ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.text) $(echo "${SOURCEFILE%.*}".text)
			echo "100|Podtitle hotowe" >> $PROGRESS
		else
			echo "100|Tuta warianta hišće njeje přistupna!" >> $PROGRESS
		fi
		;;
	
	*)
		echo "100|Tuta warianta hišće njeje přistupna!" >> $PROGRESS
		;;
	
esac
