#!/bin/bash

GIT_SSH_KEY_NAME="capstone_ed25519"
USER_NAME="Richard Robbins"
USER_EMAIL="richard.robbins@berkeley.edu"
USER_EDITOR="emacs"

REPO_ROOT=$HOME/projects

REPO_DEST_PAIRS=(
    "git@github.com:RERobbins/irvine-capstone.git $REPO_ROOT/school/"
    "git@github.com:RERobbins/data_science_266_sandbox.git $REPO_ROOT/school/"
    "git@github.com:RERobbins/devtools.git $REPO_ROOT/other/"
    "git@github.com:RERobbins/LangChain.git $REPO_ROOT/other/"
)


COMMON_DOCKER_CONTAINERS=(
    "quay.io/unstructured-io/unstructured-api:0.0.62"
)

GPU_DOCKER_CONTAINERS=(
    "quay.io/robbins/ml-jupyter-gpu:latest"
)

NON_GPU_DOCKER_CONTAINERS=(
    "quay.io/robbins/ml-jupyter:latest"
)

# Specify the desired umask value (e.g., 002 for 755 permissions on directories)
UMASK_VALUE="002"

# Check if the umask is already set in ~/.bashrc
if ! grep -q "umask" $HOME/.bashrc; then
    # If umask is not set, add it to ~/.bashrc
    echo "umask $UMASK_VALUE" >> $HOME/.bashrc
    echo "Added umask to $HOME/.bashrc"
else
    # If umask is already set, update its value in ~/.bashrc
    sed -i "s/^umask .*/umask $UMASK_VALUE/" $HOME/.bashrc
    echo "Updated umask in $HOME/.bashrc"
fi

source $HOME/.bashrc

# Update package list and upgrade installed packages
echo "Updating package list and upgrading installed packages..."
sudo apt update
sudo apt upgrade -y

# Install Emacs
echo "Installing Emacs..."
sudo apt install -y emacs

# Start the SSH agent
echo "Starting the SSH agent..."
eval "$(ssh-agent -s)"

# Add the specified SSH key to the SSH agent
echo "Adding SSH key to the SSH agent..."
ssh-add "$HOME/.ssh/$GIT_SSH_KEY_NAME"

# Configure Git
echo "Configuring Git..."
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"
git config --global core.editor "$USER_EDITOR"

# Create subdirectories
echo "Creating subdirectories..."
mkdir -p "$HOME/projects/school"
mkdir -p "$HOME/projects/other"

# Iterate over the pairs and perform git clone
for pair in "${REPO_DEST_PAIRS[@]}"; do
    # Split the pair into repository URL and destination directory
    IFS=" " read -ra parts <<< "$pair"
    repo_url="${parts[0]}"
    dest_dir="${parts[1]}"

    # Clone the repository into the specified destination directory
    echo "Cloning repository $repo_url into $dest_dir..."
    cd "$dest_dir"
    git clone "$repo_url"
done

# Check if NVIDIA GPU is present
if nvidia-smi &>/dev/null; then
    # NVIDIA GPU is present, set a variable to indicate GPU presence
    HAS_GPU=true
    echo "NVIDIA GPU is present."
else
    # No NVIDIA GPU detected, set a variable to indicate no GPU
    HAS_GPU=false
    echo "No NVIDIA GPU detected."
fi

# Pull Docker containers (always)
echo "Pulling common Docker containers..."
for image in "${COMMON_DOCKER_CONTAINERS[@]}"; do
    docker pull "$image"
done

# Check if NVIDIA GPU is present and pull GPU-specific containers
if [ "$HAS_GPU" = true ]; then
    echo "Pulling GPU-specific Docker containers..."
    for image in "${GPU_DOCKER_CONTAINERS[@]}"; do
        docker pull "$image"
    done
fi

# Check if there is no NVIDIA GPU and pull non-GPU containers
if [ "$HAS_GPU" = false ]; then
    echo "Pulling non-GPU Docker containers..."
    for image in "${NON_GPU_DOCKER_CONTAINERS[@]}"; do
        docker pull "$image"
    done
fi

echo "Setup completed!"
