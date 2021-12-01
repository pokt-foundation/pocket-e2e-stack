#!/bin/sh

echo "Starting watch.sh..."

echo "POCKET_CORE_KEY: $POCKET_CORE_KEY, POCKET_CORE_SEEDS: $POCKET_CORE_SEEDS, POCKET_CORE_PUBLIC_KEY: $POCKET_CORE_PUBLIK_KEY";

if [ -z $EXECOMMAND ]
then
  echo "Expecting EXECOMMAND env var, none was exported.";
  export EXECCOMMAND="start --seeds $POCKET_CORE_SEEDS --keybase=false --datadir=/home/app/.pocket"
  echo "Exported $EXECCOMMAND as EXECCOMMAND";
fi;

if [ -z $POCKET_PATH ]
then
  echo "Expecting POCKET_PATH env var, none was exported";
  exit 1;
fi

reflex -r '\.go' -s -- sh -c 'go run $POCKET_PATH/app/cmd/pocket_core/main.go $EXECCOMMAND';
