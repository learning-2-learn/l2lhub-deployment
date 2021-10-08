# ubuntu:20.04
# pangeo/base-image: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile
# pangeo/pangeo-notebook definition: https://github.com/pangeo-data/pangeo-docker-images/tree/master/pangeo-notebook
# pangeo/pangeo-notebook tags: https://hub.docker.com/r/pangeo/pangeo-notebook/tags
# pangeo-notebook conda package: https://github.com/conda-forge/pangeo-notebook-feedstock/blob/master/recipe/meta.yaml
#
# NOTE: pangeo/pangeo-notebook:2021.03.01 bumps JupyterLab 2 to JupyterLab 3
#       which is likeley quite breaking. 2021.02.19 is the most recent release
#       before that.
FROM pangeo/pangeo-notebook:2021.02.19
ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN echo "Installing apt-get packages..." \
    && apt-get update \
    && apt-get install -y \
        gcc \
        nano \
        octave \
        g++ \ 
    && rm -rf /var/lib/apt/lists/*
USER ${NB_USER}


# We only need to install packages not listed in this file already:
# https://github.com/pangeo-data/pangeo-docker-images/blob/master/pangeo-notebook/packages.txt
RUN echo "Installing conda packages..." \
 && mamba install -n ${CONDA_ENV} -y -c plotly \
        cython \
        google-cloud-sdk \
        plotly \
 && echo "Installing conda packages complete!"


# We only need to install packages not listed in this file already:
# https://github.com/pangeo-data/pangeo-docker-images/blob/master/pangeo-notebook/packages.txt
RUN echo "Installing pip packages..." \
 && HDF5_DIR=$NB_PYTHON_PREFIX \
    ${NB_PYTHON_PREFIX}/bin/pip install --no-cache-dir --no-binary=h5py \
        bqplot \
            # ref: https://github.com/bqplot/bqplot
        bycycle==0.1.* \
            # ref: https://github.com/bycycle-tools/bycycle
        dpca \
            # ref: https://github.com/machenslab/dPCA
        fooof==1.0.* \
            # ref: https://github.com/fooof-tools/fooof, 1.0.0 is out now
        git+https://github.com/ahwillia/tensortools@1790db3975845 \
            # ref: https://github.com/ahwillia/tensortools, pinned to a commit that works on May 17th, 2021
        git+https://github.com/h5py/h5py.git \
            # ref: https://github.com/h5py/h5py
            # NOTE: Let h5py install before HDF5Zarr
        git+https://github.com/catalystneuro/HDF5Zarr.git \
            # ref: https://github.com/catalystneuro/HDF5Zarr
        git+https://github.com/neurodsp-tools/neurodsp@ed82caa2d93606d1500de0997dce962b81bc69eb \
            # ref: https://github.com/neurodsp-tools/neurodsp
        jupyterlab_hdf \
            # NOTE: Currently does not support JupyterLab 3 it seems:
            #       https://github.com/jupyterlab/jupyterlab-hdf5/issues/42
            # NOTE: Has an associated JupyterLab extension that needs to be
            #       installed explicitly as of 2021-03-06.
            # ref: https://github.com/jupyterlab/jupyterlab-hdf5
        line_profiler \
            # ref: https://github.com/pyutils/line_profiler
        mne \
            # ref: https://github.com/mne-tools/mne-python
        nbresuse \
            # ref: https://github.com/jupyter-server/jupyter-resource-usage
        nitime \
            # ref: https://github.com/nipy/nitime
        nwbwidgets \
            # ref: https://github.com/NeurodataWithoutBorders/nwb-jupyter-widgets
        oct2py \
            # ref: https://github.com/blink1073/oct2py
        octave_kernel \
            # ref: https://github.com/Calysto/octave_kernel
        pactools \
            # ref: https://github.com/pactools/pactools
        python-picard \
            # ref: https://github.com/pierreablin/picard
        seaborn \
            # ref: https://github.com/mwaskom/seaborn
        statsmodels \
            # ref: https://github.com/statsmodels/statsmodels
        xgboost \ 
            # https://xgboost.readthedocs.io/en/latest/
        shap \ 
            # https://github.com/slundberg/shap
 && echo "Installing pip packages complete!"



RUN echo "Installing jupyterlab extensions..." \
    && export PATH=${NB_PYTHON_PREFIX}/bin:${PATH} \
    && jupyter labextension install -y --clean \
        @lckr/jupyterlab_variableinspector \
        @jupyterlab/hdf5 \
        bqplot \
 && echo "Installing jupyterlab extensions complete!"



RUN echo "Enabling jupyter serverextensions..." \
    && export PATH=${NB_PYTHON_PREFIX}/bin:${PATH} \
    && jupyter serverextension enable --sys-prefix --py nbresuse


# Configure conda to create new environments within the home folder by default.
# This allows the environments to remain in between restarts of the container
# if only the home folder is persisted.
RUN conda config --system --prepend envs_dirs '~/.conda/envs'
