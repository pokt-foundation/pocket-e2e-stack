#!/bin/bash

set -e

mkdir -p /home/app/.pocket/config

if [ -n "${POCKET_CORE_GENESIS}" ] ; then
    echo "${POCKET_CORE_GENESIS}" > /home/app/.pocket/config/genesis.json
fi

# NOTE: The default `chains.json` does not support all the chains in Pocket mainnet.
if [ -n "${POCKET_CORE_CHAINS}" ] ; then
    echo "${POCKET_CORE_CHAINS}" > /home/app/.pocket/config/chains.json
fi


/usr/bin/expect /home/app/command.sh $@
