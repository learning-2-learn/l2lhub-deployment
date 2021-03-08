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

conda activate notebook || true
pip install git+https://github.com/learning-2-learn/lfp_tools || true
