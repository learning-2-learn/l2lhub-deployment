# ubuntu:20.04
# pangeo/base-image: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile
# pangeo/pangeo-notebook definition: https://github.com/pangeo-data/pangeo-docker-images/tree/master/pangeo-notebook
# pangeo/pangeo-notebook tags: https://hub.docker.com/r/pangeo/pangeo-notebook/tags
# pangeo-notebook conda package: https://github.com/conda-forge/pangeo-notebook-feedstock/blob/master/recipe/meta.yaml
#
FROM pangeo/pangeo-notebook:2021.10.19
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
        bycycle \
            # ref: https://github.com/bycycle-tools/bycycle
        dpca \
            # ref: https://github.com/machenslab/dPCA
        fooof \
            # ref: https://github.com/fooof-tools/fooof, 1.0.0 is out now
        git+https://github.com/ahwillia/tensortools@1790db3975845 \
            # ref: https://github.com/ahwillia/tensortools, pinned to a commit that works on May 17th, 2021
        h5py \
            # ref: https://github.com/h5py/h5py
            # NOTE: Let h5py install before HDF5Zarr
        git+https://github.com/catalystneuro/HDF5Zarr.git \
            # ref: https://github.com/catalystneuro/HDF5Zarr
        neurodsp \
            # ref: https://github.com/neurodsp-tools/neurodsp
        jupyterlab_hdf \
            # ref: https://github.com/jupyterlab/jupyterlab-hdf5
        lckr-jupyterlab-variableinspector \
            # ref: https://github.com/lckr/jupyterlab-variableInspector
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
        graspologic==0.3.1.dev1346960477 \
            # Installing 0.3.0 causes an install of matplotlib 3.3.0, which in
            # turn breaks while installing. This is likely related to
            # https://github.com/microsoft/graspologic/pull/854 but I'm a bit
            # confused why we don't install an even newer version of matplotlib.
            #
            # https://github.com/microsoft/graspologic, as requested by John Ferre
 && echo "Installing pip packages complete!"


RUN echo "Enabling jupyter serverextensions..." \
    && export PATH=${NB_PYTHON_PREFIX}/bin:${PATH} \
    && jupyter serverextension enable --sys-prefix --py nbresuse


# Configure conda to create new environments within the home folder by default.
# This allows the environments to remain in between restarts of the container
# if only the home folder is persisted.
RUN conda config --system --prepend envs_dirs '~/.conda/envs'
