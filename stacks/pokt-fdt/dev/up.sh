#!/usr/bin/env bash

if [ -z $CWD ];
then
  echo "Expected CWD env var, nothing was exported";
  exit 1;
fi

POCKET_CORE_REPO_PATH=$POCKET_CORE_REPO_PATH \
GATEWAY_REPO_PATH=$GATEWAY_REPO_PATH docker-compose \
  -f $CWD/stacks/pokt-net/dev/stack.yml \
  -f $CWD/stacks/pokt-fdt/dev/stack.yml \
  --project-directory $CWD/ \
  up -d
