#!/bin/bash

# Common configuration
export USER_ID=$(id -u)
export USER_GID=$(id -g)
ML_JUPYTER_GPU_CONFIG_DIR=$HOME/projects/other/devtools/ml-jupyter-gpu

# Function to launch ML Jupyter GPU
launch-ml-jupyter-gpu () {
  local config_type=${1:-jupyter-gpu}
  if [ "$config_type" != "jupyter-gpu" ] && [ "$config_type" != "jupyter-unstructured-gpu" ]; then
    echo "Invalid argument. Usage: launch-ml-jupyter-gpu [jupyter-gpu|jupyter-unstructured-gpu]"
    return 1
  fi
  export ML_JUPYTER_GPU_DOCKER_COMPOSE_FILE="$ML_JUPYTER_GPU_CONFIG_DIR/docker-compose-$config_type.yml"
  docker compose pull -f $ML_JUPYTER_DOCKER_COMPOSE_FILE
  docker compose -f $ML_JUPYTER_GPU_DOCKER_COMPOSE_FILE up -d
}

# Function to shutdown ML Jupyter
shutdown-ml-jupyter-gpu () {
  local DEFAULT_DOCKER_COMPOSE_FILE="$ML_JUPYTER_GPU_CONFIG_DIR/docker-compose-jupyter.yml"
  local docker_compose_file=${ML_JUPYTER_GPU_DOCKER_COMPOSE_FILE:-$DEFAULT_DOCKER_COMPOSE_FILE}
  docker compose -f $docker_compose_file down
}
