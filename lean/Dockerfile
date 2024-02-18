FROM quay.io/jupyter/pytorch-notebook:2024-01-21

USER root

# Copy requirements.txt into the image
COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Clean up Conda, pip cache, and fix permissions
RUN conda clean -afy && \
    rm -rf /root/.cache/pip && \
    rm -f /tmp/requirements.txt  && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Switch back to the jovyan (or default) user
USER $NB_USER
