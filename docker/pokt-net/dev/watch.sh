#!/bin/bash

echo "Starting watch.sh..."

echo "POCKET_CORE_KEY: ${POCKET_CORE_KEY}";
echo "POCKET_CORE_SEEDS: ${POCKET_CORE_SEEDS}";
echo "POCKET_CORE_PUBLIC_KEY: ${POCKET_CORE_PUBLIK_KEY}";

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


DEBUG_COMMAND() {
  echo 'starting pocket with dlv...';

  cd ${POCKET_PATH};

  dlv_file_name="ouput_${POCKET_ADDRESS}.dlv";
  touch ${dlv_file_name};

  dlv debug ${POCKET_PATH}/app/cmd/pocket_core/main.go \
    --continue \
    --output ${dlv_file_name} \
    --headless \
    --accept-multiclient \
    --listen=:${DEBUG_PORT} \
    --api-version=2 \
    -- \
    ${EXECCOMMAND}
}

NO_DEBUG_COMMAND() {
  echo 'starting pocket without dlv...';

  cd ${POCKET_PATH};

  go run ${POCKET_PATH}/app/cmd/pocket_core/main.go ${EXECCOMMAND}
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

cd $POCKET_ROOT
reflex \
  --start-service \
  -r '\.go$' \
  -s -- /bin/bash -c "$command";