# ubuntu:20.04
# pangeo/base-image: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile
# pangeo/pangeo-notebook definition: https://github.com/pangeo-data/pangeo-docker-images/tree/master/pangeo-notebook
# pangeo/pangeo-notebook tags: https://hub.docker.com/r/pangeo/pangeo-notebook/tags
# pangeo-notebook conda package: https://github.com/conda-forge/pangeo-notebook-feedstock/blob/master/recipe/meta.yaml
FROM pangeo/pangeo-notebook:2020.11.18
ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN echo "Installing apt-get packages..." \
    && apt-get update \
    && apt-get install -y \
        gcc \
        nano \
        octave \
    && rm -rf /var/lib/apt/lists/*
USER ${NB_USER}


# We only need to install packages not listed in this file already:
# https://github.com/pangeo-data/pangeo-docker-images/blob/master/pangeo-notebook/packages.txt
RUN echo "Installing conda packages..." \
 && mamba install -c plotly \
        cython \
        google-cloud-sdk \
        plotly \
 && echo "Installing conda packages complete!"


# We only need to install packages not listed in this file already:
# https://github.com/pangeo-data/pangeo-docker-images/blob/master/pangeo-notebook/packages.txt
RUN echo "Installing pip packages..." \
 && HDF5_DIR=$NB_PYTHON_PREFIX \
    pip install --no-cache-dir --no-binary=h5py \
        bqplot \
            # ref: https://github.com/bqplot/bqplot
        bycycle==0.1.* \
            # ref: https://github.com/bycycle-tools/bycycle
        dpca \
            # ref: https://github.com/machenslab/dPCA
        fooof==1.0.* \
            # ref: https://github.com/fooof-tools/fooof, 1.0.0 is out now
        git+https://github.com/ahwillia/tensortools@v0.3.0 \
            # ref: https://github.com/ahwillia/tensortools
        git+https://github.com/h5py/h5py.git \
            # ref: https://github.com/h5py/h5py
            # NOTE: Let h5py install before HDF5Zarr
        git+https://github.com/catalystneuro/HDF5Zarr.git \
            # ref: https://github.com/catalystneuro/HDF5Zarr
        git+https://github.com/neurodsp-tools/neurodsp@ed82caa2d93606d1500de0997dce962b81bc69eb \
            # ref: https://github.com/neurodsp-tools/neurodsp
        line_profiler \
            # ref: https://github.com/pyutils/line_profiler
        mne \
            # ref: https://github.com/mne-tools/mne-python
        nbresuse \
            # ref: https://github.com/jupyter-server/jupyter-resource-usage
        # nitime \
            # ref: https://github.com/nipy/nitime
            # FIXME: nitime build fails currently. A key suspect is that our
            #        environment from pangeo-notebook use Python 3.8 instead of
            #        Python 3.7 as was used before.
        nwbwidgets \
            # ref: https://github.com/NeurodataWithoutBorders/nwb-jupyter-widgets
        oct2py \
            # ref: https://github.com/blink1073/oct2py
        octave_kernel \
            # ref: https://github.com/Calysto/octave_kernel
        pactools \
            # ref: https://github.com/pactools/pactools
        seaborn \
            # ref: https://github.com/mwaskom/seaborn
 && echo "Installing pip packages complete!"



RUN echo "Installing jupyterlab extensions..." \
    && jupyter labextension install -y --clean \
        @lckr/jupyterlab_variableinspector \
        bqplot \
 && echo "Installing jupyterlab extensions complete!"



RUN echo "Enabling jupyter serverextensions..." \
    && jupyter serverextension enable --sys-prefix --py nbresuse
