#!/bin/bash

pushd uploader-recny-model-server
echo "PORT_SLOWNIK=$PORT_SLOWNIK" > .env
popd

cd uploader-recny-model-server && npm run start:slownik
