#!/bin/bash

echo "Starting watch.sh..."

echo "POCKET_CORE_SEEDS: $POCKET_CORE_SEEDS";
echo "POCKET_ADDRESS: $POCKET_ADDRESS";
echo "POCKET_BRANCH: $POCKET_BRANCH";

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

DEBUG_COMMAND() {
  $POCKET_ROOT/prepare-tendermint.sh;
  cd $POCKET_PATH;

  dlv_file_name="ouput_${POCKET_ADDRESS}.dlv";
  touch ${dlv_file_name};

  echo 'starting pocket with dlv...';

  dlv debug $POCKET_PATH/app/cmd/pocket_core/main.go \
    --continue \
    --output ${dlv_file_name} \
    --headless \
    --accept-multiclient \
    --listen=:$DEBUG_PORT \
    --api-version=2 \
    -- \
    $EXECCOMMAND
}

NO_DEBUG_COMMAND() {
  $POCKET_ROOT/prepare-tendermint.sh;
  cd $POCKET_PATH;

  echo 'starting pocket without dlv...';
  go run $POCKET_PATH/app/cmd/pocket_core/main.go $EXECCOMMAND
}

export -f DEBUG_COMMAND
export -f NO_DEBUG_COMMAND

command=""
if [ $DEBUG==1 ];
then
  command="DEBUG_COMMAND"
else
  command="NO_DEBUG_COMMAND"
fi;

echo "About to run the following command with reflex: $command"

git --git-dir ./pocket-core/.git checkout $POCKET_BRANCH

reflex \
  --start-service \
  -r '\.go$' \
  -s -- /bin/bash -c "$command";