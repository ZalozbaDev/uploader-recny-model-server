#!/bin/bash

pushd uploader-recny-model-server
echo "PORT_DUBBING=$PORT_DUBBING" > .env
popd

echo "HF_TOKEN set to $HF_TOKEN"
echo "SOTRA_URL set to $SOTRA_URL"

cd uploader-recny-model-server && npm run start:dubbing
