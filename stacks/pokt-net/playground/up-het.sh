#!/usr/bin/env bash

docker-compose \
  -f $CWD/stacks/pokt-playground-het/docker-compose.yaml \
  --project-directory $CWD/stacks/pokt-playground-het \
  --env-file $CWD/stacks/pokt-playground-het/.env \
    up
