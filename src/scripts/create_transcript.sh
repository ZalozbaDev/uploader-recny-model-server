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
echo "Format=$OUTFORMAT"

touch $PROGRESS

# list all currently used models here

RECIKTS_MODEL_BOZA_MSA=misa_2024_08_02.cfg
RECIKTS_MODEL_GMEJNSKE=gmejnske_2024_08_21.cfg

# TBD whisper models
WHISPER_MODEL_GERMAN=large-v2

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
		echo "20|Resampling hotowe" >> $PROGRESS
		
		/whisper.cpp/main -m /whisper/hsb/whisper_small/ggml-model.bin --output-srt -f $SOURCEFILE.wav.resample.wav
		mv $SOURCEFILE.wav.resample.wav.srt $SOURCEFILE.srt
		ln -s $(basename $SOURCEFILE.srt) $(echo "${SOURCEFILE%.*}".srt)
		echo "100|Podtitle hotowe" >> $PROGRESS
		
		/whisper.cpp/main -m /whisper/hsb/whisper_small/ggml-model.bin --output-txt -f $SOURCEFILE.wav.resample.wav
		mv $SOURCEFILE.wav.resample.wav.txt $SOURCEFILE.text
		ln -s $(basename $SOURCEFILE.text) $(echo "${SOURCEFILE%.*}".text)
		echo "100|Tekst hotowe" >> $PROGRESS
		;;
	
	HFBIG)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		DURATION=${DURATION%.*}  # strip the decimal part
		DURATION=$(( "$DURATION" * "3" ))
		echo $DURATION > $PROGRESS.tmp 
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe" >> $PROGRESS
		if [ "$OUTFORMAT" = "srt" ]; then
			/whisper.cpp/main -m /whisper/hsb/whisper_large/ggml-model.bin --output-srt -f $SOURCEFILE.wav.resample.wav
			mv $SOURCEFILE.wav.resample.wav.srt $SOURCEFILE.srt
			ln -s $(basename $SOURCEFILE.srt) $(echo "${SOURCEFILE%.*}".srt)
			echo "100|Podtitle hotowe" >> $PROGRESS
		else
			/whisper.cpp/main -m /whisper/hsb/whisper_large/ggml-model.bin --output-txt -f $SOURCEFILE.wav.resample.wav
			mv $SOURCEFILE.wav.resample.wav.txt $SOURCEFILE.text
			ln -s $(basename $SOURCEFILE.text) $(echo "${SOURCEFILE%.*}".text)
			echo "100|Tekst hotowe" >> $PROGRESS
		fi
		;;
	
	EURO)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe" >> $PROGRESS

		echo "100|Podtitle hotowe" >> $PROGRESS


		echo "100|Tekst hotowe" >> $PROGRESS

		;;
	
	FB)
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
	
	BOZA_MSA)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe" >> $PROGRESS
		LD_LIBRARY_PATH=/proprietary /proprietary/testrec /proprietary/$RECIKTS_MODEL_BOZA_MSA $SOURCEFILE.wav.resample.wav | tee $SOURCEFILE.wav.resample.wav.rec.log
		echo "80|Spóznawanje hotowe" >> $PROGRESS
		if [ "$OUTFORMAT" = "srt" ]; then
			python3 $(dirname $0)/log2srt.py $SOURCEFILE.wav.resample.wav.rec.log
			mv uploads/${FOLDERNAME}/*.srt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.srt) $(echo "${SOURCEFILE%.*}".srt)
			echo "100|Podtitle hotowe" >> $PROGRESS
			echo "----> HOTOWE <----"
		else
			python3 $(dirname $0)/log2txt.py $SOURCEFILE.wav.resample.wav.rec.log
			mv uploads/${FOLDERNAME}/*.rawtxt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.text) $(echo "${SOURCEFILE%.*}".text)
			echo "100|Tekst hotowe" >> $PROGRESS
			echo "----> HOTOWE <----"
		fi
		;;
		
	GMEJ)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 16000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe" >> $PROGRESS
		LD_LIBRARY_PATH=/proprietary /proprietary/testrec /proprietary/$RECIKTS_MODEL_GMEJNSKE $SOURCEFILE.wav.resample.wav | tee $SOURCEFILE.wav.resample.wav.rec.log
		echo "80|Spóznawanje hotowe" >> $PROGRESS
		if [ "$OUTFORMAT" = "srt" ]; then
			python3 $(dirname $0)/log2srt.py $SOURCEFILE.wav.resample.wav.rec.log
			mv uploads/${FOLDERNAME}/*.srt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.srt) $(echo "${SOURCEFILE%.*}".srt)
			echo "100|Podtitle hotowe" >> $PROGRESS
			echo "----> HOTOWE <----"
		else
			python3 $(dirname $0)/log2txt.py $SOURCEFILE.wav.resample.wav.rec.log
			mv uploads/${FOLDERNAME}/*.rawtxt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.text) $(echo "${SOURCEFILE%.*}".text)
			echo "100|Tekst hotowe" >> $PROGRESS
			echo "----> HOTOWE <----"
		fi
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
		cp $SOURCEFILE.wav.resample.wav.rec.log ${SOURCEFILE}.${OUTFORMAT}
		ln -s $(basename $SOURCEFILE.${OUTFORMAT}) $(echo "${SOURCEFILE%.*}".${OUTFORMAT})
		echo "100|Podtitle hotowe" >> $PROGRESS
		# echo "-1"  >> $PROGRESS
		echo "----> HOTOWE <----"
		;;

	HF_PAU)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 48000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe" >> $PROGRESS
		/whisper_main /whisper/hsb/whisper_small/ggml-model.bin $SOURCEFILE.wav.resample.wav ./uploads/${FOLDERNAME} > ./uploads/${FOLDERNAME}/log.txt 2>&1
		if [ "$OUTFORMAT" = "srt" ]; then
			mv uploads/${FOLDERNAME}/subtitles.srt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.srt) $(echo "${SOURCEFILE%.*}".srt)
			echo "100|Podtitle hotowe" >> $PROGRESS
		else
			mv uploads/${FOLDERNAME}/transcript.txt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.text) $(echo "${SOURCEFILE%.*}".text)
			echo "100|Tekst hotowe" >> $PROGRESS
		fi
		;;
	
	HFBIG_PAU)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		DURATION=${DURATION%.*}  # strip the decimal part
		DURATION=$(( "$DURATION" * "3" ))
		echo $DURATION > $PROGRESS.tmp 
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 48000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe" >> $PROGRESS
		/whisper_main /whisper/hsb/whisper_large/ggml-model.bin $SOURCEFILE.wav.resample.wav ./uploads/${FOLDERNAME} > ./uploads/${FOLDERNAME}/log.txt 2>&1
		if [ "$OUTFORMAT" = "srt" ]; then
			mv uploads/${FOLDERNAME}/subtitles.srt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.srt) $(echo "${SOURCEFILE%.*}".srt)
			echo "100|Podtitle hotowe" >> $PROGRESS
		else
			mv uploads/${FOLDERNAME}/transcript.txt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.text) $(echo "${SOURCEFILE%.*}".text)
			echo "100|Tekst hotowe" >> $PROGRESS
		fi
		;;
	
	
	BOZA_MSA_PAU)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 48000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe" >> $PROGRESS
		LD_LIBRARY_PATH=/proprietary /recikts_main /proprietary/$RECIKTS_MODEL_BOZA_MSA $SOURCEFILE.wav.resample.wav ./uploads/${FOLDERNAME} > ./uploads/${FOLDERNAME}/log.txt 2>&1
		echo "80|Spóznawanje hotowe" >> $PROGRESS
		if [ "$OUTFORMAT" = "srt" ]; then
			mv uploads/${FOLDERNAME}/subtitles.srt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.srt) $(echo "${SOURCEFILE%.*}".srt)
			echo "100|Podtitle hotowe" >> $PROGRESS
		else
			mv uploads/${FOLDERNAME}/transcript.txt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.text) $(echo "${SOURCEFILE%.*}".text)
			echo "100|Tekst hotowe" >> $PROGRESS
		fi
		;;
		
	GMEJ_PAU)
		echo "0|Wobdźěłam $SOURCEFILE" >> $PROGRESS
		ffmpeg -i $SOURCEFILE $SOURCEFILE.wav
		DURATION=$(soxi -D $SOURCEFILE.wav)
		echo ${DURATION%.*} > $PROGRESS.tmp # strip the decimal part
		cat $PROGRESS >> $PROGRESS.tmp
		mv $PROGRESS.tmp $PROGRESS
		sox $SOURCEFILE.wav -r 48000 -c 1 -b 16 $SOURCEFILE.wav.resample.wav
		echo "20|Resampling hotowe" >> $PROGRESS
		LD_LIBRARY_PATH=/proprietary /recikts_main /proprietary/$RECIKTS_MODEL_GMEJNSKE $SOURCEFILE.wav.resample.wav ./uploads/${FOLDERNAME} > ./uploads/${FOLDERNAME}/log.txt 2>&1
		echo "80|Spóznawanje hotowe" >> $PROGRESS
		if [ "$OUTFORMAT" = "srt" ]; then
			mv uploads/${FOLDERNAME}/subtitles.srt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.srt) $(echo "${SOURCEFILE%.*}".srt)
			echo "100|Podtitle hotowe" >> $PROGRESS
		else
			mv uploads/${FOLDERNAME}/transcript.txt ${SOURCEFILE}.${OUTFORMAT}
			ln -s $(basename $SOURCEFILE.text) $(echo "${SOURCEFILE%.*}".text)
			echo "100|Tekst hotowe" >> $PROGRESS
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
		whisper-ctranslate2 --model $WHISPER_MODEL_GERMAN --output_dir /uploader-recny-model-server/uploads/${FOLDERNAME}/ --device cpu --language de /uploader-recny-model-server/$SOURCEFILE.wav.resample.wav > /uploader-recny-model-server/uploads/${FOLDERNAME}/log.log 2>&1
		popd
		if [ "$OUTFORMAT" = "srt" ]; then
			mv ${SOURCEFILE%.*}*.srt $(echo "${SOURCEFILE%.*}".srt)
			echo "100|Podtitle hotowe" >> $PROGRESS
		else
			mv ${SOURCEFILE%.*}*.txt $(echo "${SOURCEFILE%.*}".text)
			echo "100|Tekst hotowe" >> $PROGRESS
		fi
		;;
		
	*)
		echo "100|Tuta warianta hišće njeje přistupna!" >> $PROGRESS
		;;
	
esac
