#!/bin/bash

pushd /forcealign
source bin/activate

echo "forcealign called with args $1 $2 $3"

python3 align_wav2vec2.py $1 $2 $3

echo "forcealign DONE"

popd
