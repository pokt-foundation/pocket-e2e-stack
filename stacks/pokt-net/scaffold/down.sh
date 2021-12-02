#!/usr/bin/env bash

docker-compose \
  -f $CWD/stacks/pokt-net/scaffold/stack.yml \
  --project-directory $CWD/ \
  down 

echo 'Done';
