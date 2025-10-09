#!/bin/bash

pushd /forcealign
source bin/activate

echo "forcealign called with args 1=$1 2=$2 3=$3"

ffmpeg -i $1 $1.wav

python3 align_wav2vec2.py $1.wav $2 $3

echo "forcealign DONE"

popd
