#!/usr/bin/env bash

function get_nodes_data_volumes_paths() {
  nodes=$(ls $CWD/stacks/pokt-net/playground | grep node | awk '{print $1}')
  nodes=${nodes//[[:blank:]]/}

  if [[ $nodes == "" ]]; then
    echo 0
  fi

  paths=($(echo $nodes | tr " " "\n" | tr -d " "))
  echo $paths
}

function clean_data_folders_for_nodes() {
  paths=$1
}

function clean() {
  echo "Cleaning $1...";
  rm -rf $1/*
}

function reset_possible_mistakes() {
  git checkout -- $CWD/stacks/pokt-net/playground/
}

clean $CWD/stacks/pokt-net/playground/
paths=$(get_nodes_data_volumes_paths)

if [[ $paths != 0 && ${#paths[@]} != 0 ]]; then
  echo "Leftover data folders detected."
  for i in "${!paths[@]}"
  do
    clean $CWD/stacks/pokt-net/playground/${paths[i]}/data
    clean $CWD/stacks/pokt-net/playground/${paths[i]}
  done
fi

reset_possible_mistakes
echo 'Done';
