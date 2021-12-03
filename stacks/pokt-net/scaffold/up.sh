#!/usr/bin/env bash

create_data_folder() {
  mkdir -p $1/data/
}

create_data_folders_for_nodes() {
  paths=$1
  for i in "${!paths[@]}"
  do
    create_data_folder $CWD/stacks/pokt-net/playground/${paths[i]}
  done
}

export POCKET_CORE_REPOS_PATH=$POCKET_CORE_REPOS_PATH
export POCKET_E2E_STACK_RELATIVE_PATH=$(basename -a $POCKET_E2E_STACK_PATH)

docker-compose \
  -f $CWD/stacks/pokt-net/scaffold/stack.yml \
  --project-directory $CWD/ \
  up \
  --build \
  --force-recreate

echo "Copying playground .env to proper path..."
cp $CWD/.playground.env $CWD/playground/.env

nodes=$(ls $CWD/stacks/pokt-net/full | grep node | awk '{print $1}')
paths=($(echo $nodes | tr " " "\n"))

echo "Creating data folders for the generated nodes..."
create_data_folders_for_nodes $paths

echo 'Done';
