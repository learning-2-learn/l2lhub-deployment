# This file is mounted to /usr/local/etc/jupyter and can be used to inject some
# jupyterhub/server-proxy definitions for example.

# c.ServerProxy.servers = {
#   'we-nipreps-esteban': {
#     'command': ['python3', '-m', 'http.server', '--directory', '/home/jovyan/data/openneuro/ds000114/derivatives/fmriprep-20.2.0rc0/fmriprep/', '{port}'],
#   },
#   'we-nilearn-dupre': {
#     'command': ['python3', '-m', 'http.server', '--directory', '/nh/curriculum/we-nilearn-dupre/book', '{port}'],
#   }
# }

# To allow intense communication between browser and the server, as required
# for example by plotly and itk-jupyter-widgets with 3D things.
c.NotebookApp.iopub_data_rate_limit = 1e12

# Configuration of nb_conda_kernels that converts conda environments to conda
# kernels, but only those that are not already listed.
#
# ref: https://github.com/Anaconda-Platform/nb_conda_kernels
c.CondaKernelSpecManager.name_format = '{1}'
# This filter is to avoid having the jupyterlab launcher show a duplicated entry
# for Python and Octave as there are two duplicated environments, the "base" and
# "notebook" conda environment. Like this, we only use the "base" environment
# which should be the same.
c.CondaKernelSpecManager.env_filter = '"((?!envs/notebook).)*"'
