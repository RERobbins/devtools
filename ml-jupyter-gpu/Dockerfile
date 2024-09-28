FROM cschranz/gpu-jupyter:v1.7_cuda-12.2_ubuntu-22.04_python-only

LABEL maintainer="Richard Robbins"

USER root

# Update the system and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libmagic-dev \
        jq \
        emacs-nox && \
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

# Create Conda environments for Python 3.8, 3.9, and 3.10 as desired and install necessary packages in each environment
# ARG env_names="python_3.8 python_3.9 python_3.10"
# ARG env_names="python_3.10"

# RUN for env_name in $env_names; do \
#        case $env_name in \
#            python_3.8) py_ver=3.8;; \
#            python_3.9) py_ver=3.9;; \
#            python_3.10) py_ver=3.10;; \
#            python_3.11) py_ver=3.11;; \
#        esac; \
#        mamba create --yes -p "${CONDA_DIR}/envs/${env_name}" \
#        python=${py_ver} \
#        'ipykernel' \
#        'jupyterlab' && \
#        "${CONDA_DIR}/envs/${env_name}/bin/python" -m ipykernel install --user --name="${env_name}" && \
#        "${CONDA_DIR}/envs/${env_name}/bin/pip" install --no-cache-dir -r /tmp/requirements.txt; \
#     done && \
#     mamba clean --all -f -y && \
#     rm -f /tmp/requirements.txt

# Clean up Conda, pip cache, and fix permissions
RUN conda clean -afy && \
    rm -rf /root/.cache/pip && \
    rm -f /tmp/requirements.txt  && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Switch back to the jovyan (or default) user
USER $NB_USER
