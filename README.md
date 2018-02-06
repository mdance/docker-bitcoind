
# docker-bitcoind

Updated on 2018-02-05.

[![Docker Stars](https://img.shields.io/docker/stars/bcawthra/bitcoind.svg)](https://hub.docker.com/r/bcawthra/bitcoind/)
[![Docker Pulls](https://img.shields.io/docker/pulls/bcawthra/bitcoind.svg)](https://hub.docker.com/r/bcawthra/bitcoind/)

A Docker configuration with sane defaults for running a full validating 
Bitcoin node.

Credits to https://github.com/jamesob/docker-bitcoind.

## Quick start

Requires that [Docker be installed](https://docs.docker.com/engine/installation/) on the host machine.

```
# Create some directory where your bitcoin data will be stored.
$ mkdir /home/youruser/bitcoin_data

$ docker run --name bitcoind -d \
   --env 'BTC_RPCUSER=foo' \
   --env 'BTC_RPCPASSWORD=password' \
   --volume /home/youruser/bitcoin_data:/bitcoin \
   -p 8332:8332
   --publish 8333:8333
   jamesob/bitcoind

$ docker logs -f bitcoind
[ ... ]
```

## Configuration

A custom `bitcoin.conf` file can be placed in the mounted data directory.
Otherwise, a default `bitcoin.conf` file will be automatically generated based
on environment variables passed to the container:

| name | default |
| ---- | ------- |
| BTC_RPCUSER | btc |
| BTC_RPCPASSWORD | changemeplz |
| BTC_RPCPORT | 8332 |
| BTC_RPCALLOWIP | ::/0 |
| BTC_RPCCLIENTTIMEOUT | 30 |


## Daemonizing

If you're using systemd, you can use a config file like

```
$ cat /etc/systemd/system/bitcoind.service

# bitcoind.service #######################################################################
[Unit]
Description=Bitcoind
After=docker.service
Requires=docker.service
 
[Service]
ExecStartPre=-/usr/bin/docker kill bitcoind
ExecStartPre=-/usr/bin/docker rm bitcoind
ExecStartPre=/usr/bin/docker pull jamesob/bitcoind
ExecStart=/usr/bin/docker run \
    --name bitcoind \
    -p 8333:8333 \
    -p 8332:8332 \
    -v /data/bitcoind:/bitcoin \
    jamesob/bitcoind 
ExecStop=/usr/bin/docker stop bitcoind 
```

to ensure that bitcoind continues to run.


## Other References

- https://github.com/bonovoxly/bitcoin-node - Easily deploy a bitcoin node to AWS or Google Cloud.
- https://github.com/bonovoxly/gke-bitcoin-node - Easily deploy a bitcoin node to Google Kubernetes Engine.
