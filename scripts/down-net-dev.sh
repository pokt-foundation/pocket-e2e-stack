#!/usr/bin/env bash

docker-compose \
  -f stacks/pokt-net-dev.yml \
  --project-directory ./ \
  down