#/usr/bin/env bash

function check_env_var() {
  local env_value="${!1}"
  if [ -z "${env_value}" ]; then
    echo "${1} is not set"
    exit 1
  fi
}

function check_required_env_vars() {
  check_env_var "POCKET_CORE_REPOS_PATH"
  check_env_var "POCKET_CORE_REPO_PATH"
  check_env_var "POCKET_NETWORK_TENDERMINT_PATH"
  check_env_var "POCKET_E2E_STACK_PATH"
}

# TODO(olshansky): this is a bit hacky so consider refactoring.
function update_chains_json() {
  if [[ ! -z ${PNF_USERNAME} && ! -z ${PNF_PASSWORD} ]]; then
    echo "PNF_USERNAME and PNF_PASSWORD are set so we are going update chains.json"
    sed "s/\"username\": \"\${PNF_USERNAME}\"/\"username\": \"${PNF_USERNAME}\"/g" stacks/pokt-net/shared/chains.template.json > stacks/pokt-net/shared/chains.local.json
    sed -i '' "s/\"password\": \"\${PNF_PASSWORD}\"/\"password\": \"${PNF_PASSWORD}\"/g" stacks/pokt-net/shared/chains.local.json
  fi
}

function check_docker() {
  if ! docker info > /dev/null 2>&1; then
    echo "Docker is not installed or running. Going to try and start it..."
    open /Applications/Docker.app
    sleep 3
    while (! docker stats --no-stream ); do
      echo "Waiting for Docker to launch..."
      sleep 3
    done
  fi

  swarm_status="$(docker info --format '{{.Swarm.LocalNodeState}}')"
  if [ "$swarm_status" != "active" ]; then
    echo "Docker not in swarm mode. Going to try and initialize it..."
    docker swarm init > /dev/null 2>&1
  fi
}

check_required_env_vars
check_docker
update_chains_json

# Call the pokt-net stack.
./bin/pkt-stack pokt-net dev-tm up
