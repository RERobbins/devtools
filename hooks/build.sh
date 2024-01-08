#!/bin/bash
# Multi-platform build script for Docker Hub

# Define the platforms
PLATFORMS="linux/amd64,linux/arm64"

# Define the tags
LATEST_TAG="latest"
DATE_TAG="$(date +%Y-%m-%d)"

# Build and push for all specified platforms with both tags
docker buildx build \
  --platform $PLATFORMS \
  --tag $DOCKER_REPO:$LATEST_TAG \
  --tag $DOCKER_REPO:$DATE_TAG \
  --push \
  .
