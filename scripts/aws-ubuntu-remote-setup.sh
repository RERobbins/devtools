#!/bin/bash
umask 002

# You should only need to modify the next four definitions
GIT_SSH_KEY_NAME="capstone_ed25519"
USER_NAME="Richard Robbins"
USER_EMAIL="RERobbins@itinker.net"
USER_EDITOR="emacs"

REPO_ROOT=$HOME/projects

REPO_DEST_PAIRS=(
    "git@github.com:RERobbins/irvine-capstone.git $REPO_ROOT/school/"
    "git@github.com:RERobbins/devtools.git $REPO_ROOT/other/"
)


# Container setup has been moved back into the AMI setup phase 
# COMMON_DOCKER_CONTAINERS=()
# GPU_DOCKER_CONTAINERS=("quay.io/robbins/ml-jupyter-gpu:latest")
# NON_GPU_DOCKER_CONTAINERS=("quay.io/robbins/ml-jupyter:latest")

# Update package list and upgrade installed packages
echo "Updating package list and upgrading installed packages..."
sudo apt update
sudo apt upgrade -y

# Installatino of Emacs has been moved back into the AMI setup phase
# echo "Installing Emacs..."
# sudo apt install -y emacs

# Define the path to the SSH config file
ssh_config_file="$HOME/.ssh/config"

# Append or create the SSH config entry for GitHub
cat <<EOL >> "$ssh_config_file"
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/$GIT_SSH_KEY_NAME
EOL

echo "SSH config file has been updated with GitHub SSH key settings for $GIT_SSH_KEY_NAME."

# Set appropriate permissions for the SSH config file
chmod 600 "$ssh_config_file"

echo "Permissions for SSH config file have been set."

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

# All container related setup has been moved back into the AMI setup phase

# Check if NVIDIA GPU is present
#if nvidia-smi &>/dev/null; then
#    # NVIDIA GPU is present, set a variable to indicate GPU presence
#    HAS_GPU=true
#    echo "NVIDIA GPU is present."
#else
#    # No NVIDIA GPU detected, set a variable to indicate no GPU
#    HAS_GPU=false
#    echo "No NVIDIA GPU detected."
#fi

# Pull Docker containers (always)
#echo "Pulling common Docker containers..."
#for image in "${COMMON_DOCKER_CONTAINERS[@]}"; do
#    docker pull "$image"
#done

# Check if NVIDIA GPU is present and pull GPU-specific containers
#if [ "$HAS_GPU" = true ]; then
#    echo "Pulling GPU-specific Docker containers..."
#    for image in "${GPU_DOCKER_CONTAINERS[@]}"; do
#        docker pull "$image"
#    done
#fi

# Check if there is no NVIDIA GPU and pull non-GPU containers
#if [ "$HAS_GPU" = false ]; then
#    echo "Pulling non-GPU Docker containers..."
#    for image in "${NON_GPU_DOCKER_CONTAINERS[@]}"; do
#        docker pull "$image"
#    done
#fi

echo "Setup completed!"