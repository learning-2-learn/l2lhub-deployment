gcloud container node-pools create \
    --machine-type=n1-highmem-4 \
    --num-nodes=1 \
    --enable-autoscaling \
    --min-nodes=1 --max-nodes=1000 \
    --region=us-central1 \
    --node-labels hub.jupyter.org/node-purpose=user \
    --node-taints hub.jupyter.org_dedicated=user:NoSchedule \
    --no-enable-autoupgrade \
    --cluster=l2l-jhub-2019-12-19 \
    user-pool-2019-12-19

