#!/bin/bash

set -exuo pipefail

BITCOIN_DIR=/bitcoin
BITCOIN_CONF=${BITCOIN_DIR}/bitcoin.conf

# If config doesn't exist, initialize with sane defaults for running a 
# non-mining node.

if [ ! -e "${BITCOIN_CONF}" ]; then
  cat >${BITCOIN_CONF} <<EOF

# For documentation on the config file, see
#
# the bitcoin source: 
#   https://github.com/bitcoin/bitcoin/blob/master/contrib/debian/examples/bitcoin.conf
# the wiki: 
#   https://en.bitcoin.it/wiki/Running_Bitcoin

# enable prune mode support (0=disabled, 1=RPC auto, > 550 stay under targetted MB)
prune=${BTC_PRUNE:-0}

# server=1 tells Bitcoin-Qt and bitcoind to accept JSON-RPC commands
server=1

# You must set rpcuser and rpcpassword to secure the JSON-RPC api
rpcuser=${BTC_RPCUSER:-btc}
rpcpassword=${BTC_RPCPASSWORD:-changemeplz}

# How many seconds bitcoin will wait for a complete RPC HTTP request.
# after the HTTP connection is established. 
rpcclienttimeout=${BTC_RPCCLIENTTIMEOUT:-30}

rpcallowip=${BTC_RPCALLOWIP:-::/0}

# Listen for RPC connections on this TCP port:
rpcport=${BTC_RPCPORT:-8332}

# Print to console (stdout) so that "docker logs bitcoind" prints useful
# information.
printtoconsole=${BTC_PRINTTOCONSOLE:-1}

# We probably don't want to mine, and thus don't need a wallet.
disablewallet=${BTC_DISABLEWALLET:-1}

# If we want to keep an index of all transactions
txindex=${BTC_TXINDEX:-0}
EOF
fi

if [ $# -eq 0 ]; then
  exec bitcoind -datadir=${BITCOIN_DIR} -conf=${BITCOIN_CONF} "$@"
else
  exec "$@"
fi
