#!/usr/bin/env bash

if [ -z $CWD ];
then
  echo "Expected CWD env var, nothing was exported";
  exit 1;
fi

export POCKET_E2E_STACK_RELATIVE_PATH=$(basename $POCKET_E2E_STACK_PATH)
export POCKET_CORE_REPO_RELATIVE_PATH=$(basename $POCKET_CORE_REPO_PATH)
export POCKET_NETWORK_TENDERMINT_RELATIVE_PATH=$(basename $POCKET_NETWORK_TENDERMINT_PATH)

docker-compose \
  -f $CWD/stacks/pokt-net/dev-tm/stack.yml \
  --project-directory $CWD/ \
  up \
  --build \
  --force-recreate
