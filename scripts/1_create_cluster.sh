gcloud container clusters create \
  --enable-autoscaling \
  --min-nodes=1 --max-nodes=3 \
  --machine-type n1-highmem-2 \
  --num-nodes 1 \
  --enable-network-policy \
  --node-labels hub.jupyter.org/node-purpose=core \
  --region=us-central1 --node-locations=us-central1-b \
  --cluster-version latest \
    l2l-jhub-2019-12-19