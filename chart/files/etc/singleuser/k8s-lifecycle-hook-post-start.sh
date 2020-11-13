#/bin/bash
# This script is configured to run with a k8s postStart lifecycle hook and must
# be very robust, a failure leads to failure for the user pod to start. This is
# also a script very hard to debug because its stdout output is discarded on
# success and only available on failures which we want to avoid at all cost.

echo "Do nothing."
