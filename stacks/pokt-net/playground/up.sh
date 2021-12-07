#!/usr/bin/env bash

docker-compose \
  -f $CWD/stacks/pokt-playground/docker-compose.yaml \
  --project-directory $CWD/stacks/pokt-playground \
  --env-file $CWD/stacks/pokt-playground/.env \
    up
