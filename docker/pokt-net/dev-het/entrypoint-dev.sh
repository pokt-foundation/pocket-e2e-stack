#!/bin/bash

set -e

mkdir -p /home/app/.pocket/config

if [ -n "${POCKET_CORE_GENESIS}" ] ; then
    echo "${POCKET_CORE_GENESIS}" > /home/app/.pocket/config/genesis.json
fi

if [ -n "${POCKET_CORE_CHAINS}" ] ; then
    echo "${POCKET_CORE_CHAINS}" > /home/app/.pocket/config/chains.json
fi

# git checkout ${POCKET_BRANCH}

/usr/bin/expect /home/app/command.sh $@
