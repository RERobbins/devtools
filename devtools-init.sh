#build_rer_ml_jupyterlab() {
#    local DATE_TAG=$(date +%Y-%m-%d)
#    docker buildx build \
#	   --platform linux/amd64,linux/arm64 \
#	   -t "quay.io/robbins/devtools/rer_ml_jupyterlab:$DATE_TAG" \
#	   -t "quay.io/robbins/devtools/rer_ml_jupyterlab:latest" \
#	   --push \
#	   $HOME/projects/other/devtools
#    docker build \
#	   -t "quay.io/robbins/devtools/rer_ml_jupyterlab:$DATE_TAG" \
#	   -t "quay.io/robbins/devtools/rer_ml_jupyterlab:latest" \
#	   $HOME/projects/other/devtools
#}

build_rer_ml_jupyterlab() {
    local DATE_TAG=$(date +%Y-%m-%d)
    local push_to_registry=${1:-true} # Default is true for pushing to the registry

    # Determine the build command based on whether we're pushing to registry or saving locally
    if [ "$push_to_registry" = true ] ; then
        # Using buildx to build and push for multi-platform images
        docker buildx build \
           --platform linux/amd64,linux/arm64 \
           -t "quay.io/robbins/devtools/rer_ml_jupyterlab:$DATE_TAG" \
           -t "quay.io/robbins/devtools/rer_ml_jupyterlab:latest" \
           --push \
           $HOME/projects/other/devtools
    else
        # Regular docker build for local save
        docker build \
           -t "quay.io/robbins/devtools/rer_ml_jupyterlab:$DATE_TAG" \
           -t "quay.io/robbins/devtools/rer_ml_jupyterlab:latest" \
           $HOME/projects/other/devtools
    fi
}

rer_ml_jupyterlab() {
  # Set the UID and GID to match the current user
  export NB_UID=$(id -u)
  export NB_GID=$(id -g)

  if [ -z "$1" ] || [ "$1" = "unstructured" ]; then
    # Set environment variable to "unstructured"
    export RER_ML_CONFIG="unstructured"
    # Launch "unstructured" containers (default)
    docker compose -f $HOME/projects/other/devtools/docker-compose.yml up -d
  elif [ "$1" = "slender" ]; then
    # Set environment variable to "slender"
    export RER_ML_CONFIG="slender"
    # Launch "slender" containers
    docker compose -f $HOME/projects/other/devtools/docker-compose-slender.yml up -d
  else
    # Display an error message if the argument is not recognized
    echo "Invalid argument. Usage: rer_ml_jupyterlab [unstructured|slender]"
  fi
}


shutdown_rer_ml_jupyterlab() {
    if [ -z "$RER_ML_CONFIG" ] || [ "$RER_ML_CONFIG" = "unstructured" ]; then
	# Shut down "unstructured" containers (default)
	docker compose -f $HOME/projects/other/devtools/docker-compose.yml down
    elif [ "$RER_ML_CONFIG" = "slender" ]; then
	# Shut down "slender" containers
	docker compose -f $HOME/projects/other/devtools/docker-compose-slender.yml down
    else
	echo "Invalid configuration stored in RER_ML_CONFIG environment variable."
    fi
}
