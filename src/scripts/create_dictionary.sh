#!/bin/bash

if [ "$#" -ne 8 ]; then
	echo "need to run this script with the following arguments:"
	echo "./create_dictionary.sh FOLDER DUMMYSOURCEFILENAME DUMMYLANGUAGEMODEL PHONMAP EXCEPTIONS CORPUS OUTPUTFORMAT PROGRESSFILE"
	echo "Example:"
	echo "./create_dictionary.sh 672536cdbea8737853 dummycorpus dummy phonmap.txt exceptions.txt corpus.vocab SAMPA progress.txt"
	echo " 100|Error in number args $1 $2 $3 $4 $5 $6 $7 $8 " > /debugging.txt
	exit -1
fi

FOLDERNAME=$1
SOURCEFILE=$2
MODEL=$3
PHONMAP=$4
EXCEPTIONS=$5
CORPUS=$6
OUTFORMAT=$7
PROGRESS=$8


echo "Dataja=$SOURCEFILE"
echo "Postup=$PROGRESS"
echo "Rjadowak=$FOLDERNAME"
echo "Model=$MODEL"
echo "Format=$OUTFORMAT"
echo "Phonmap=$PHONMAP"
echo "Exceptions=$EXCEPTIONS"
echo "Corpus=$CORPUS"

touch $PROGRESS

echo "0|Wobdźěłam $CORPUS" >> $PROGRESS

# copy tooling and config from external repo
mkdir -p uploads/$FOLDERNAME/corpus_creator/
cp -r /speech_recognition_corpus_creation/examples/ex9/configuration uploads/$FOLDERNAME/corpus_creator/
cp -r /speech_recognition_corpus_creation/examples/ex9/tooling       uploads/$FOLDERNAME/corpus_creator/
mkdir -p uploads/$FOLDERNAME/corpus_creator/resources/

echo "10" > $PROGRESS.tmp # strip the decimal part
cat $PROGRESS >> $PROGRESS.tmp
mv $PROGRESS.tmp $PROGRESS

# copy uploaded files to expected folders
cp $PHONMAP    uploads/$FOLDERNAME/corpus_creator/configuration/phonmap.txt
cp $EXCEPTIONS uploads/$FOLDERNAME/corpus_creator/configuration/exceptions.txt
cp $CORPUS     uploads/$FOLDERNAME/corpus_creator/resources/corpus.vocab

# run tooling
pushd uploads/$FOLDERNAME/corpus_creator/tooling/
python3 corpus_creator.py ../configuration/web.yaml
popd

echo "80|Słownik hotowe" >> $PROGRESS

case $OUTFORMAT in

	SAMPA)
		echo "100|Hotowe" >> $PROGRESS
		;;
	
	KALDI)
		echo "100|Hotowe" >> $PROGRESS
		;;
	
	UASR)
		echo "100|Hotowe" >> $PROGRESS
		;;
	
	*)
		echo "100|Tutón format njeznaju!" >> $PROGRESS
		;;
	
esac
	