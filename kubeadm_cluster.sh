#!/bin/bash

# This execution must be done with root user, so execute sudo -s before execute this script 

usage() {
cat <<EOF
Usage: $0 -i [PARAMs]
NOTE: This execution must be done with root user, so execute sudo -s before execute this script 
Example of the execution:
sudo ./kubeadm_cluster.sh -i 104.209.168.116 -r master
-u                  : Display usage
-i [ip]         	: ip = IP of the machine (required)
-r [role]         	: role = type of role wished: master or node
EOF
}
  
function create_master(){
	# First update packages

	echo "»» Update packages"
	apt-get update -y

	echo "»» Install docker.io"
	apt-get install -qy docker.io

	echo "»» Update packages, add gpg key"
	apt-get update && apt-get install -y apt-transport-https && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

	echo "»» deb kubernetes"
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update

	echo "»» Update and install kube*"
	apt-get update && apt-get install -y kubelet kubeadm kubernetes-cni

	echo "»» Initialize kubeadm"
	set -x
	kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$IP
	set +x

	echo "»» Kube config"
	sudo cp /etc/kubernetes/admin.conf $HOME/
	sudo chown $(id -u):$(id -g) $HOME/admin.conf
	export KUBECONFIG=$HOME/admin.conf
	echo "export KUBECONFIG=$HOME/admin.conf" | tee -a ~/.bashrc

}

function create_node(){
	echo "»» Update packages"
	apt-get update -y

	echo "»» Install docker.io"
	apt-get install -qy docker.io

	echo "»» Update packages, add gpg key"
	apt-get update && apt-get install -y apt-transport-https && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

	echo "»» deb kubernetes"
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update

	echo "»» Update and install kube*"
	apt-get update && apt-get install -y kubelet kubeadm kubernetes-cni
}

function create_cluster_role() {

	if [ "$ROLE" == "node" ]; then
		create_node
	else
		create_master
	fi
}

IP=
ROLE=

while getopts ":i:u:r" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    i)
      IP=${OPTARG}
      ;;
    r)
      ROLE=${OPTARG}
      ;;
    ?)
      usage
      exit
      ;;
    esac
done

if [[ -z $IP ]]; then
  usage
  exit 1
fi

create_cluster_role $IP $ROLE