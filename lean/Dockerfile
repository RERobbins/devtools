FROM quay.io/jupyter/pytorch-notebook:2024-01-21

USER root

# Update the system and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        scikit-learn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get remove -y --purge build-essential && \
    apt-get autoremove -y && \
    rm -rf /tmp/*

# Copy requirements.txt into the image
COPY requirements.txt /tmp/requirements.txt

# Assuming base environment is already Python 3.11, install requirements into it and rename it
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    jq '.display_name = "python_3.11"' /opt/conda/share/jupyter/kernels/python3/kernel.json > /tmp/kernel.json.modified && \
    mv /tmp/kernel.json.modified /opt/conda/share/jupyter/kernels/python3/kernel.json

# Clean up Conda, pip cache, and fix permissions
RUN conda clean -afy && \
    rm -rf /root/.cache/pip && \
    rm -f /tmp/requirements.txt  && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Switch back to the jovyan (or default) user
USER $NB_USER
