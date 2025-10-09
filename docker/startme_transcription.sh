#!/bin/bash

pushd uploader-recny-model-server
echo "PORT_TRANSCRIPT=$PORT_TRANSCRIPT" > .env
popd

echo "SOTRA_URL set to $SOTRA_URL"
echo "HF_TOKEN set to $HF_TOKEN"

cd uploader-recny-model-server && npm run start:transcript
