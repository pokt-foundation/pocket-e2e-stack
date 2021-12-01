#!/bin/sh

echo "Starting watch.sh..."

echo "POCKET_CORE_KEY: $POCKET_CORE_KEY, POCKET_CORE_SEEDS: $POCKET_CORE_SEEDS, POCKET_CORE_PUBLIC_KEY: $POCKET_CORE_PUBLIK_KEY";

if [ -z $EXECOMMAND ]
then
  echo "Expecting EXECOMMAND env var, none was exported.";
  export EXECCOMMANDACTION="start"
  export EXECCOMMANDFLAGS="--seeds $POCKET_CORE_SEEDS --keybase=false --datadir=/home/app/.pocket"
  export EXECCOMMAND="$EXECCOMMANDACTION $EXECCOMMANDFLAGS"
  echo "Exported $EXECCOMMAND as EXECCOMMAND";
fi;

if [ -z $POCKET_PATH ]
then
  echo "Expecting POCKET_PATH env var, none was exported";
  exit 1;
fi

command=''
if [ $DEBUG==1 ];
then
  command="touch output.dlv && dlv debug $POCKET_PATH/app/cmd/pocket_core/main.go --continue --output output.dlv --headless --accept-multiclient --listen=:$DEBUG_PORT --api-version=2 -- $EXECCOMMAND"
else
  command="go run $POCKET_PATH/app/cmd/pocket_core/main.go $EXECCOMMAND"
fi;

echo $command
reflex \
  --start-service \
  -r '\.go' \
  -s -- sh -c $command;

