# About

This website contain documentation related to Learning-2-Learn's JupyterHub
deployment maintained in the [aws-2020 branch of
learning-2-learn/l2lhub-deployment](https://github.com/learning-2-learn/l2lhub-deployment/tree/aws-2020).

## Domain
It is currently made available at https://l2l.sundellopensource.com, and the
docs is made available at https://docs.l2l.sundellopensource.com.

```{note}
To update the domain you need to:

1. Search and replace the domain name in this git repo.
2. Add a CNAME entry for the new domain name towards `a7720f5811365404fb3f4a2eb7975c77-1737265599.us-west-2.elb.amazonaws.com.` for the JupyterHub deployment.
3. Add a CNAME entry for the new domain name towards `learning-2-learn.github.io` for the docs deployment.
4. Update the [GitHub repository settings](https://github.com/learning-2-learn/l2lhub-deployment/settings) or the `CNAME` file in the `gh-pages` branch as well.
```

## Access

Access to the deployed JupyterHub restricted to a selection of GitHub accounts defined in
deployments/l2l/common.yaml. Just make a change there and the deployment will
update.

## Storage

The storage for each user are network attached storage disks, 10GB per user.

```{note}
For something more fancy, for example when one wants to manage backups or have
many more users with a flexible storage requirement it would probably make sense
to use a NFS server to provision storage space instead. To my knowledge,
deploying [this Helm
chart](https://github.com/kubernetes-sigs/nfs-ganesha-server-and-external-provisioner/tree/master/deploy/helm)
is the best path forward to pursue this.
```

## Cloud infra setup

The cloud infrastructure _configuration as code_, but there is no CI automation
if it changes so please see the configuration files for details on how to update
it if you make a change to it. When making changes, use your personal high
privilege account.

### Kubernetes cluster

We use AWS EKS as a k8s cluster setup with [eksctl](https://eksctl.io/). This
k8s cluster is declared in `infra/eksctl-cluster-config.yaml`.

If you are to make changes to the k8s cluster, for example upgrade its version, see the inline comments in that file.

### Additional cloud infra

We declare additional parts for hubploy automation running in GitHub CI system
that can be found in `infra/cloudformation-hubploy.yaml`.

- IAM User `hubploy`, and AccessKey that can be used in GitHub's CI system.
- IAM Roles `hubploy-ecr` and `hubploy-eks`, that the `hubploy` user can
  _assume_ for ECR/EKS permissions.
- KMS Key, that the hubploy user can use as backend for
  [mozilla/sops](https://github.com/mozilla/sops) to encrypt/decrypt.
- ECR Repository `l2l/user-env`

## Maintenance procedures

### Configuring AWS credentials and k8s cluster credentials

`kubectl`, `eksctl`, `hubploy`, `sops` all require credentials that can be provided by setting `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

If you have high permissions in the AWS account, you can probably after having configured your `AWS_` prefixed environment variables use the following command to configure `kubectl` to know how to access the k8s cluster.

```shell
# configure kubectl to have access to the k8s cluster
eksctl utils write-kubeconfig --config-file=infra/eksctl-cluster-config.yaml

# test if access was setup correctly
kubectl get namespaces
```

This has been tried to function by Erik using kubectl version `1.23.8` and `0.95.0` for the AWS account `erik`, and an `AWS_ACCESS_KEY_ID` ending with the letters `OPU`, at 2022-07-11.

### To upgrade the k8s version

Erik has documented the upgrade procedure in another `eksctl` based deployment, and that can be used as a guide. See [this inline comment of another project's `eksctl` config](https://github.com/consideRatio/pilot-hubs/blob/3456e3599603e9f2de250669c246b8063829a067/eksctl/eksctl-cluster-config.yaml#L39-L92).

In brief, the k8s api-server's version should only be upgraded one minor version at the time. The k8s node's part of the k8s cluster though can be upgraded one step off sync with the k8s api-server, so for example to upgrade from 1.18 to 1.22, one can do the following steps.

1. Upgrade k8s api-server 1.18->1.19
2. Upgrade all k8s nodes version from 1.18->1.20
3. Upgrade k8s api-server 1.18->1.20
4. Upgrade k8s api-server 1.18->1.21
5. Upgrade all k8s nodes version from 1.18->1.22
6. Upgrade k8s api-server 1.18->1.22

For details on commands to use in this upgrade, see the above linked inline comment in another eksctl configuration file.

### To upgrade the JupyterHub and Dask-Gateway Helm charts

This project has its own Helm chart defined in the [git repository's `chart/` folder](https://github.com/learning-2-learn/l2lhub-deployment/blob/HEAD/chart/Chart.yaml). It is declaring a Helm chart dependency on `daskhub`, which is just a simple Helm chart configuring some glue between the `jupyterhub` helm chart and the `dask-gateway` helm charts.

To upgrade `jupyterhub` and or `dask-gateway` we must upgrade `daskhub`, which is done in that configuration file. There is a lengthier note in that file about what to think about when making an upgrade of `daskhub`.

The actual upgrade happens if [the GitHub automation](https://github.com/learning-2-learn/l2lhub-deployment/blob/HEAD/.github/workflows/deploy-aws.yaml) is triggered by pushing a git commit or manually as documented in the topic below.

### To deploy using using `hubploy`

This is documented to its most up to date state within [the github workflow doing it](https://github.com/learning-2-learn/l2lhub-deployment/blob/HEAD/.github/workflows/deploy-aws.yaml).

Note that the `hubploy` user in AWS is not itself granted permissions, but is relying on the permissions granted to a role to interact with `ecr` and `eks` respectively. Due to that complexity, when you use `hubploy` the CLI you may need to use a `hubploy` `AWS_ACCESS_KEY_ID` - for example the one ending with `SDB` with its associated `AWS_SECRET_ACCESS_KEY`.

### To make changes to the user environment image

If you make a change to [the Dockerfile](https://github.com/learning-2-learn/l2lhub-deployment/blob/HEAD/deployments/l2l/image/Dockerfile) and push those changes, `hubploy` will take care of building and making sure that that image is used based on [configuration for hubploy](https://github.com/learning-2-learn/l2lhub-deployment/blob/aws-2020/deployments/l2l/hubploy.yaml#L7-L15).
