#!/bin/bash

pushd uploader-recny-model-server
echo "PORT_DUBBING=$PORT_DUBBING" > .env
popd

cd uploader-recny-model-server && npm run start:dubbing
