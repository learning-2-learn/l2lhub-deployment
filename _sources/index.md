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
Access is restricted to a selection of GitHub accounts defined in
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

### Additional cloud infra
We declare additional parts for hubploy automation running in GitHub CI system
that can be found in `infra/cloudformation-hubploy.yaml`.

- IAM User `hubploy`, and AccessKey that can be used in GitHub's CI system.
- IAM Roles `hubploy-ecr` and `hubploy-eks`, that the `hubploy` user can
  _assume_ for ECR/EKS permissions.
- KMS Key, that the hubploy user can use as backend for
  [mozilla/sops](https://github.com/mozilla/sops) to encrypt/decrypt.
- ECR Repository `l2l/user-env`
