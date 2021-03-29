#/bin/bash
# This script is configured to run with a k8s postStart lifecycle hook and must
# be very robust, a failure leads to failure for the user pod to start. This is
# also a script very hard to debug because its stdout output is discarded on
# success and only available on failures which we want to avoid at all cost.
#
# k8s lifecycleHooks reference:
# https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/
#
# I'm not sure appending "|| true" will work to ensure no individual line cause
# this script to fail. If so, then perhaps this could work:
# https://stackoverflow.com/questions/64786/error-handling-in-bash

# Always install the latest lfp_tools which is in active development
pip install git+https://github.com/learning-2-learn/lfp_tools || true

# Always re-set restrictive permissions on the SSH keys, as our NFS storage
# setup cause it to have default permissions on pod restart. The reason for
# having restrictive permissions is that tools will react if they are too high.
# If a user wants to update these, the user would just need to elevate
# permissions as an owner of the files first.
chmod 400 /home/jovyan/.ssh/id_* || true
chmod 600 /home/jovyan/.ssh/known_hosts || true
