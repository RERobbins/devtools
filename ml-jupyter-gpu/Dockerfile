FROM quay.io/jupyter/pytorch-notebook:cuda12-ubuntu-24.04
LABEL maintainer="Richard Robbins"

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        emacs-nox \
	tzdata  && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements.txt file to the container
COPY requirements.txt /tmp/requirements.txt

# Install packages from requirements.txt
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    rm -rf /root/.cache/pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose Jupyter port
EXPOSE 8888

# Set up Jupyter Lab to run on container start
CMD ["jupyter-lab", "--no-browser"]
