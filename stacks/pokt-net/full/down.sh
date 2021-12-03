#!/usr/bin/env bash

docker-compose \
  -f $CWD/stacks/pokt-net/full/docker-compose.yaml \
  --project-directory $CWD/stacks/pokt-net/full \
  --env-file $CWD/stacks/pokt-net/full/.env \
  rm --stop --force
