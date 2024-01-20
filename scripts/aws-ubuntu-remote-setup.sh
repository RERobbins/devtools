#!/bin/bash

GIT_SSH_KEY_NAME="capstone_ed25519"
USER_NAME="Richard Robbins"
USER_EMAIL="richard.robbins@berkeley.edu"
USER_EDITOR="emacs"

DOCKER_IMAGE_TAGS=(
    "quay.io/robbins/ml-jupyter:latest"
    "quay.io/robbins/ml-jupyter-gpu:latest"
    "quay.io/unstructured-io/unstructured-api:0.0.62"
)

REPO_ROOT=$HOME/projects

REPO_DEST_PAIRS=(
    git@github.com:RERobbins/irvine-capstone.git $REPO_ROOT/school/irvine-capstone
    git@github.com:RERobbins/data_science_266_sandbox.git $REPO_ROOT/school/data_science_266_sandbox
    git@github.com:RERobbins/devtools.git $REPO_ROOT/other/devtools
    git@github.com:RERobbins/LangChain.git $REPO_ROOT/other/LangChain
)

# Update package list and upgrade installed packages
sudo apt update
sudo apt upgrade -y

# Install Emacs
sudo apt install -y emacs

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add the specified SSH key to the SSH agent
ssh-add "$HOME/.ssh/$GIT_SSH_KEY_NAME"

# Configure Git
git config --global user.email $USER_EMAIL
git config --global user.name $USER_NAME
git config --global core.editor $USER_EDITOR

# Create subdirectories
mkdir -p $HOME/projects/school
mkdir -p $HOME/projects/other

# Iterate over the pairs and perform git clone
for pair in "${REPO_DEST_PAIRS[@]}"; do
    # Split the pair into repository URL and destination directory
    IFS=" " read -ra parts <<< "$pair"
    repo_url="${parts[0]}"
    dest_dir="${parts[1]}"

    # Clone the repository into the specified destination directory
    git clone "$repo_url" "$dest_dir"

# Iterate over the image tags and pull each image
for image_tag in "${DOCKER_IMAGE_TAGS[@]}"; do
    echo "Pulling Docker image: $image_tag"
    docker pull "$image_tag"
done

echo "Setup completed!"
