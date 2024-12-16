FROM quay.io/jupyter/pytorch-notebook:ubuntu-24.04
LABEL maintainer="Richard Robbins"

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=America/Chicago

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends emacs-nox tzdata  && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    rm -rf /root/.cache/pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

