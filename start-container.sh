#!/bin/bash
docker \
run \
--env-file .env \
--volume $PWD/data:/bitcoin \
-p 8332:8332 \
-p 8333:8333 \
mdance/bitcoind:latest