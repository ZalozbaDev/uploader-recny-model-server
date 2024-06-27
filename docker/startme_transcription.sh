#!/bin/bash

pushd uploader-recny-model-server
echo "PORT_TRANSCRIPT=$PORT_TRANSCRIPT" > .env
popd

cd uploader-recny-model-server && npm run start:transcript
