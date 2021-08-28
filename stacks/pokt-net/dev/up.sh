#!/usr/bin/env bash

if [ -z $CWD ];
then
  echo "Expected CWD env var, nothing was exported";
  exit 1;
fi

/bin/bash $CWD/bin/copy-pokt-net-dev-scripts

docker-compose \
  -f $CWD/stacks/pokt-net/dev/stack.yml \
  --project-directory $CWD/ \
  up -d \
  --build \
  --force-recreate
