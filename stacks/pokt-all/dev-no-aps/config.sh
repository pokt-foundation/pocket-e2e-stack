#!/usr/bin/env bash

/bin/bash $(pwd)/scripts/copy-pocket-core-scripts.sh

UID=${UID} \
GID=${GID} \
CWD=$CWD \
POCKET_CORE_REPO_PATH=$POCKET_CORE_REPO_PATH \
POCKETJS_REPO_PATH=$POCKETJS_REPO_PATH \
GATEWAY_REPO_PATH=$GATEWAY_REPO_PATH docker-compose \
  -f stacks/pokt-net-dev.yml \
  -f stacks/bc-ipfs.yml \
  -f stacks/pokt-fdt-dev.yml \
  -f stacks/pokt-aps.yml \
  -f stacks/pokt-all-dev-no-aps.yml \
  --project-directory ./ \
  up \
  --build \
  --force-recreate
