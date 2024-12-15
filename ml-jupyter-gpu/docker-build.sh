build-ml-jupyter-gpu () {
    local DATE_TAG=$(date +%Y-%m-%d)
    local push_to_registry=${1:-true} # Default is true for pushing to the registry
    local TAG_BASE="quay.io/robbins/ml-jupyter-gpu"
    local BUILD_DIR="$HOME/projects/other/devtools/ml-jupyter-gpu"

    # Ensure the build directory exists
    if [ ! -d "$BUILD_DIR" ]; then
        echo "Error: Build directory $BUILD_DIR does not exist."
        return 1
    fi

    # Determine the build command based on whether we're pushing to registry or saving locally
    if [ "$push_to_registry" = true ] ; then
        # Using buildx to build and push for multi-platform images
        docker buildx build \
           --platform linux/amd64 \
           -f "$BUILD_DIR/Dockerfile" \
           -t "$TAG_BASE:$DATE_TAG" \
           -t "$TAG_BASE:latest" \
           --push \
           "$BUILD_DIR"
    else
        # Regular docker build for local save
        docker buildx build \
           --platform linux/amd64 \
           -f "$BUILD_DIR/Dockerfile" \
           -t "$TAG_BASE:$DATE_TAG" \
           -t "$TAG_BASE:latest" \
           --load \
           "$BUILD_DIR"
    fi
}

