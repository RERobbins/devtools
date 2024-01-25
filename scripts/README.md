# Your ML-Jupyter Virtual Machine

## Overview

Your ML-Jupyter virtual machine is an Ubuntu virtual machine that uses Docker to run a version of JupyterLab set up for machine learning work.  The Docker container is built from the Jupyter PyTorch Docker stack.  To learn more about Jupyter Docker Stacks go [here](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html).  As of the date of this document, I have supplemented the Docker image with the following:

```
black[jupyter]==23.12.1
isort==5.13.2
tqdm==4.66.1
python-magic==0.4.27
jupyterlab-code-formatter==2.2.1
transformers==4.36.2
tensorflow==2.15.0
torch==2.1.2
torchvision==0.16.2
torchaudio==2.1.2
unstructured==0.12.0
unstructured-client==0.15.2
python-dotenv==1.0.0
pymongo==4.6.1
tiktoken==0.5.2
openai==1.8.0
azure-search-documents==11.4.0
azure-identity==1.15.0
boto3==1.34.21
langchain==0.1.1
langchain-openai==0.0.2.post1
llama-index==0.9.33
```
We may choose to update the Docker image with new software.  The scripts we use to run Docker check for updates.

I maintain our Docker images at https://quay.io/user/robbins/.  For your reference, the Dockerfiles used to build the images are in the `devtools` github repository discussed below.  

## Prerequisites

1. The setup process relies on two shell scripts contained in my `devtools` github repository.  That repository is located at https://github.com/RERobbins/devtools.  Clone `devtools` to your local computer.  Note:  For ease of use, please create `~/projects/other/` on your local computer and clone `devtools` there.  By doing so you will minimize changes in future steps.

2. The IP address of your virtual machine.

3. A copy of the key pair to connect to your virtual machine (typically a `pem` file) on your local computer.

4. Copies of both the private ssh key and public ssh key used to connect to github (often named `id_ed25519` and `id_ed25519.pub`).  If you have not used ssh keys to connect to github or need a reminder on how to create those keys, please see the instructions [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-age).  If you create a new key pair for this purpose you will also need to add it to your github account. Instructions for that are [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account). Note: When creating these keys I find it easiest to accept the defaults for the file name and location but you are free to choose your own.  I do not use passphrases with these keys and by taking the defaults know that they are stored in a secure location on my computer. 

5. A working connection to the team VPN.  While not required, we have found the OpenVPN client works well.  See https://openvpn.net/client/.

## Preparing the Setup Scripts

The setup process involves running two scripts, the first, on your local computer and the second, on your virtual machine.  Each script needs to be revised before use.

#### The Local Script: `aws-ubuntu-local-setup.sh`

The local setup script appears at `~/projects/other/devtools/scripts/aws-ubuntu-local-setup.sh` (or wherever you cloned the `devtools` repository).

The first few lines of that script look like this:

```
#!/bin/bash

# You should only need to modify the next three definitions
SSH_KEY_PATH="$HOME/.ssh/irvine-capstone-rer-key-pair.pem"
GIT_SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
LOCAL_SETUP_SCRIPT_PATH="$HOME/projects/other/devtools/scripts/aws-ubuntu-remote-setup.sh"
```
Modify the `SSH_KEY_PATH` and `GIT_SSH_KEY_PATH` lines to refer to the key pair file used to connect to your virtual machine and the private key for accessing git, respectively.  The script assumes the public key for git has the same name as the private key, but with a `.pub` extension.

If you cloned `devtools` into some place other than `~/projects/other/devtools/` you will also need to adjust the following line.

#### The Remote Script: `aws-ubuntu-remote-setup.sh`

The remote setup script appears at `~/projects/other/devtools/scripts/aws-ubuntu-remote-setup.sh` (or wherever you cloned the `devtools` repository).

The first few lines of that script look like this:

```
#!/bin/bash
umask 002

# You should only need to modify the next four definitions
GIT_SSH_KEY_NAME="id_ed25519"
USER_NAME="the name you use on git here"
USER_EMAIL="your git email here"
USER_EDITOR="nano"
```
Modify the `GIT_SSH_KEY_NAME` variable to match the name of your private github key.  You only need the name here and not a path.  The `USER_NAME` and `USER_EMAIL` values should be the name and email address you use on github.  If you want to tell git to use a particular editor, change the `USER_EDITOR` variable.  I prefer `emacs`.  You should put your preferred editor, i.e., `vi`, `nano` etc there. 

## Running the Setup Scripts

1. Connect to the VPN using OpenVPN or your preferred vpn client.
2. On your local machine, change the working directory to the scripts directory `cd ~/projects/other/devtools/scripts/`
3. Run the local script `./aws-ubuntu-local-setup.sh your-vm-ip-address-here`

    If all goes well, the script will start an `ssh` session and copy the necessary keys and the remote setup script to your virtual machine and then leave you at a command prompt on your virtual machine.

4. Run the remote script `~./aws-ubuntu-remote-setup.sh`

    You need to run the remote script from the remote machine.  The local script should have copied the setup files to the remote machine and then left you with a working command prompt on the remote machine.  You should only need to invoke the remote script with the command above.  Do not return to your local machine to run this command.

    The script will pause in a few places to ask you to add various unrecognized hosts (like github.com) to lists of known hosts.  The script may also pause when updating software and ask about things like restarting various system processes.  You can accept defaults and if you get a screen asking about restarting processes you may safely tab to `OK` and let things proceed.

    There may be some pauses here and there.

    When you are done you may safely delete `aws-ubuntu-remote-setup.sh`.

    At this point you should either log out and log back in or source .bashrc with `source .bashrc`

## Running JupyterLab

To run our JupyterLab container on a CPU only vm, use `launch-ml-jupyter` and to shut it down, use `shutdown-ml-jupyter`.

To run our JupyterLab container on a  GPU vm, use `launch-ml-jupyter-gpu` and to shut it down, use `shutdown-ml-jupyter-gpu`.

Your virtual machine has been set up with a projects directory.  When you run the JupyterLab container, it will mount your virtual machine's projects directory into its filespace.  So, your work in that directory will persist on your virtual machine even when you shutdown the container.  As you will recall from prior classes, the default user name inside a JupyterLab container is `jovyan`.  Your `projects` directory appears as `/home/jovyan/work/` inside the container.

Access JupyterLab from a browser on your local computer by pointing it at `http://replace-with-your-vm-ip-address:8888`.

Since we are running inside a secure private network, I have disabled the familiar JupyterLab token process.  This is not unusual when running JupyterLab in a secure environment.

If you explore your virtual machine you will notice that I have cloned our capstone team repository and that is part of what gets mounted inside JupyterLab.  Everyone has a personal file space inside our capstone team repository.  So, your work in the team repo from your virtual machine can be pushed to github and shared with the team.

## Accessing Your Virtual Machine

Your AWS virtual machine can be accessed using `ssh` once you are connected to the VPN.  There are many ways to accomplish that.  All you need is your key file and an `ssh` client.

For your convenience, the `devtools` repository has a script called `aws-ssh.sh`.  That script takes two parameters, the ip address of the virtual machine and the user name for your account on that virtual machine, which defaults to `ubuntu` (which corresponds to the default user name on your aws images).

The first few lines of that script look like:
```
#!/bin/bash

# You should only need to modify the following definition
SSH_KEY_PATH="$HOME/.ssh/irvine-capstone-rer-key-pair.pem"
```
If you modify the `SSH_KEY_PATH` line to point to the key file you use to access your AWS virtual machines, you will be able to start an `ssh` session to your virtual machine with `./aws-ssh.sh your-ip-address-here`.

## Using Our Docker Images From Your Local Computer

The focus of this document has been on setting up and using our `ML-Jupyter` containers from our AWS development environment.  And while we anticipate keeping our data only in that environment, the containers described here are general purpose, data-science focused development environments that I am building out with generative AI programming mind.  The cpu only version of the container is built to run on both Intel/AMD systems as well as Apple silicon systems.  I have tested the containers on current versions of the Mac OS as well as Windows 11 with WSL and pure Linux Ubuntu systems.  The only requirement to running on these platforms is Docker.  The gpu version of our container only runs on Intel/AMD Linux systems with Nvidia GPUs and CUDA 12 drivers.  I expect I could build images for earlier CUDA drivers.  Because of how WSL works, getting our GPU container with a Windows system running WSL involves additional work.  If you are interested in doing that work, let me know. 

The various scripts in the `devops` repo that mananage those containers can be used on your local machine.  The AWS installation process masks all of that for you.

If you are interested in running the containers on your local computers (without our project data) and have any questions, let me know.