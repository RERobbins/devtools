#!/bin/bash

# Common configuration
export USER_ID=$(id -u)
export USER_GID=$(id -g)
ML_JUPYTER_CONFIG_DIR=$HOME/projects/other/devtools/ml-jupyter


# Function to launch ML Jupyter
launch-ml-jupyter() {
  local config_type=${1:-jupyter}
  if [ "$config_type" != "jupyter" ] && [ "$config_type" != "jupyter-unstructured" ]; then
    echo "Invalid argument. Usage: launch-ml-jupyter [jupyter|jupyter-unstructured]"
    return 1
  fi
  export ML_JUPYTER_DOCKER_COMPOSE_FILE="$ML_JUPYTER_CONFIG_DIR/docker-compose-$config_type.yml"
  docker-compose -f $ML_JUPYTER_DOCKER_COMPOSE_FILE up -d
}

# Function to shutdown ML Jupyter
shutdown-ml-jupyter() {
  local DEFAULT_DOCKER_COMPOSE_FILE="$ML_JUPYTER_CONFIG_DIR/docker-compose-jupyter.yml"
  local docker_compose_file=${ML_JUPYTER_DOCKER_COMPOSE_FILE:-$DEFAULT_DOCKER_COMPOSE_FILE}
  docker-compose -f $docker_compose_file down
}
