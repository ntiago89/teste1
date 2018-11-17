#!/bin/bash

# !Important note!: This execution must be done with root user, so execute sudo -s before execute this script
# Extra note: this is an experimental test/version, so some errors could be found. For example, missing validations. Sorry for that. :)
# This script is prepared to be executed on a VM instance at Google Cloud Platform. Some changes must be done for other platforms.

# Based in the following links:
# - https://www.youtube.com/watch?v=6ZRphF0wGAM
# - https://raw.githubusercontent.com/onap/logging-analytics/master/deploy/rancher/oom_rancher_setup.sh
# - https://stackoverflow.com/questions/47184213/regex-to-match-ip-addresses-but-ignore-localhost

echo " "
read -p "Are you using regular user and not root?
If yes press enter to continue.
If press ctrl+c to abort."

echo "»» Kube config:"
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
echo \"export KUBECONFIG=$HOME/admin.conf\" | tee -a ~/.bashrc

echo "»» Kube network config:"
kubectl apply --filename https://git.io/weave-kube-1.6
