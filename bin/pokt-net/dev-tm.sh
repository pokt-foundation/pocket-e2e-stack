#/usr/bin/env bash

source ./bin/pokt-net/utils.sh

source_and_export_env
check_required_env_vars
check_docker
update_chains_json

ACTION=$1

if [[ -z $ACTION ]];
then
   echo "Launching pokt-net localnet development environment..."
  ./bin/pkt-stack pokt-net dev-tm up
else
  ./bin/pkt-stack pokt-net dev-tm $ACTION
fi
