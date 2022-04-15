#/usr/bin/env bash

source ./bin/pokt-net/utils.sh

function exit_on_non_zero_code() {
  if [[ $1 != 0 ]]; then
    exit 1;
  fi
}

function is_playground_scaffolded() {
  if [[ ! -f "$CWD/stacks/pokt-playground/docker-compose.yaml" ]]; then
    echo 0;
  else
    echo 1;
  fi
}

function verify_scaffolding() {
  quiet_check_env_var "SCAFFOLD"
  WANT_TO_SCAFFOLD=$([ "$?" == 0 ] && echo 1 || echo 0)

  local scaffolding_exists=$(is_playground_scaffolded)
  if [[ WANT_TO_SCAFFOLD -eq 0 ]]; then
    echo "SCAFFOLDING is set to false, no playground generation will occur.";

    if [[ scaffolding_exists -eq 0 ]]; then
      echo "No playground scaffolding was found.";
      echo "You have to scaffold your playground before you can use it";
      return 1;
    else
      echo "Playground scaffolding was found";
      echo "Carrying on";
      return 0;
    fi
  else
    echo "SCAFFOLDING is set to true, the playground will be generated according to the provided config.";
    if [[ scaffolding_exists -eq 0 ]]; then
      echo "No playground scaffolding was found.";
      echo "Carrying on";
      return 0;
    else
      echo "Playground scaffolding already exists!";
      echo "Either set SCAFFOLD to 0 or cleanup your old scaffolding before you generator a new one";
      echo "To do so: run ./bin/pokt-net/playground.sh cleanup"
      return 1;
    fi
  fi
}

source_and_export_env
check_required_env_vars
check_docker
update_chains_json

ACTION=$1

case $ACTION in
  "cleanup")
    ./bin/pkt-stack pokt-net scaffold cleanup
    ;;

  "down")
    verify_scaffolding
    if [[ $? != 1 ]]; then
      echo "No stack is scaffolded, cannot bring down a non-existent stack."
      exit 1;
    fi
    ./bin/pkt-stack pokt-net playground down
    ;;

  "scaffold")
     export SCAFFOLD=1
     verify_scaffolding
     exit_on_non_zero_code $?
     ./bin/pkt-stack pokt-net scaffold up
    ;;

  "up")
    export SCAFFOLD=0
    verify_scaffolding
    if [[ $? != 1 ]]; then
      echo "No stack is scaffolded. You must run `./bin/pkt-stack pokt-net scaffold up` first."
      exit 1;
    fi
    ./bin/pkt-stack pokt-net playground up
    ;;

  "up-het")
    ./bin/pkt-stack pokt-net playground up-het
    ;;

  *)
    echo "Undetermined action="${ACTION}"..."
    echo "Attempting to run action=${ACTION}"
    ./bin/pkt-stack pokt-net playground $ACTION
    ;;
esac
