#!/bin/bash

docker run --gpus all \
  --ipc=host \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \   
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
  -v /home/rerobbins:/home/dockeruser \
  -v /models:/models \
  -p 8888:8888 \
  quay.io/robbins/ml-jupyter-gpu:latest
