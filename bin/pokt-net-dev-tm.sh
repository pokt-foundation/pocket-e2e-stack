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

# TODO(olshansky): Discuss in PR if these helpers even be committed to the repo (put in a shared reusable space) or discarded.
check_required_env_vars
check_docker
./bin/pkt-stack pokt-net dev-tm up
