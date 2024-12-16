#!/bin/bash

docker run --gpus all \
  --ipc=host \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
  -v $HOME/projects:/home/jovyan/work \
  -v /models:/models \
  -p 8888:8888 \
  quay.io/jupyter/pytorch-notebook:cuda12-ubuntu-24.04

