build_rer_ml_jupyterlab_cpu() {
    local DATE_TAG=$(date +%Y-%m-%d)
    local push_to_registry=${1:-true} # Default is true for pushing to the registry
    local TAG_BASE="quay.io/robbins/ml-jupyter"
    local BUILD_DIR=$HOME/projects/other/devtools/ml-jupyter/

    # Determine the build command based on whether we're pushing to registry or saving locally
    if [ "$push_to_registry" = true ] ; then
        # Using buildx to build and push for multi-platform images
        docker buildx build \
           --platform linux/amd64,linux/arm64 \
           -f $BUILD_DIR/Dockerfile \
           -t "$TAG_BASE:$DATE_TAG" \
           -t "$TAG_BASE:latest" \
           --push \
           $BUILD_DIR
    else
        # Regular docker build for local save
        docker build \
           -f $BUILD_DIR/Dockerfile \
           -t "$TAG_BASE:$DATE_TAG" \
           -t "$TAG_BASE:latest" \
           $BUILD_DIR
    fi
}
