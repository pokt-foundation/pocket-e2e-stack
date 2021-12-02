#/usr/bin/env bash

source ./bin/pokt-net/utils.sh

source_and_export_env
check_required_env_vars
check_docker
update_chains_json

function is_playground_scaffolded() {
  if [[ ! -f "$CWD/stacks/pokt-net/full/docker-compose.yaml" ]]; then
    echo 0;
  else
    echo 1;
  fi
}

quiet_check_env_var "SCAFFOLD"
WANT_TO_SCAFFOLD=$([ "$?" == 0 ] && echo 1 || echo 0)
ACTION=$1

function verify_scaffolding() {
  local scaffolding_exists=$(is_playground_scaffolded)
  if [[ WANT_TO_SCAFFOLD -eq 0 ]]; then
    echo "SCAFFOLDING is set to false, no playground generation will occur.";

    if [[ scaffolding_exists -eq 0 ]]; then
      echo "No playground scaffolding was found.";
      echo "You have to scaffold your playground before you can use it";
      exit 1;
    else
      echo "Playground scaffolding was found";
      echo "Carrying on";
    fi
  else
    echo "SCAFFOLDING is set to true, the playground will be generated according to the provided config.";
    if [[ scaffolding_exists -eq 0 ]]; then
      echo "No playground scaffolding was found.";
      echo "Carrying on, with the generation";
    else
      echo "Playground scaffolding was found";
      echo "You have to cleanup your old scaffolding before you generator a new one";
      echo "To do so: run ./bin/pokt-net/playground cleanup"
      exit 1;
    fi
  fi
}

if [[ "${ACTION}" != "cleanup" ]]; then
  verify_scaffolding
fi

case $ACTION in
  "cleanup")
    ./bin/pkt-stack pokt-net scaffold cleanup
    ;;

  "down")
    ./bin/pkt-stack pokt-net playground down
    ;;

  "up")
    if [[ $SCAFFOLD == 1 ]]; then
      ./bin/pkt-stack pokt-net scaffold up
    fi
    ./bin/pkt-stack pokt-net playground up
    ;;

  *)
    ./bin/pkt-stack pokt-net playground $ACTION
    ;;
esac
