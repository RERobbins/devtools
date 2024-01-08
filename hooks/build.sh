#!/bin/bash
# Multi-platform build script for Docker Hub

# Define the platforms
PLATFORMS="linux/amd64,linux/arm64"

# Define the tags
LATEST_TAG="$DOCKER_REPO:latest"
DATE_TAG="$DOCKER_REPO:$(date +%Y-%m-%d)"

# Build and push for all specified platforms with both tags
docker buildx build \
  --platform $PLATFORMS \
  --tag $LATEST_TAG \
  --tag $DATE_TAG \
  --push \
  .
