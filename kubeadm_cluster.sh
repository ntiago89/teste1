#!/bin/bash

# !Important note!: This execution must be done with root user, so execute sudo -s before execute this script
# Extra note: this is an experimental test/version, so some errors could be found. For example, missing validations. Sorry for that. :)
# This script is prepared to be executed on a VM instance at Google Cloud Platform. Some changes must be done for other platforms.

# Based in the following links:
# - https://www.youtube.com/watch?v=6ZRphF0wGAM
# - https://raw.githubusercontent.com/onap/logging-analytics/master/deploy/rancher/oom_rancher_setup.sh
# - https://stackoverflow.com/questions/47184213/regex-to-match-ip-addresses-but-ignore-localhost


usage() {
cat <<EOF
Usage: $0 -r [PARAMs]
NOTE: This execution must be done with root user, so execute sudo -s before execute this script 
Example of the execution:
source ./kubeadm_cluster.sh -r master [-i 104.209.168.116]
-u                      : Display usage
-r [role]               : role = type of role wished: master or node (required)
-i [ip]                 : ip = Public IP of the machine
EOF
}

function create_master(){
	# First update packages

	printf "\n»» Update packages\n"
	sudo apt-get update -y

	printf "\n»» Install docker.io\n"
	sudo apt-get install -qy docker.io

	printf "\n»» Update packages, add gpg key\n"
	sudo apt-get update && sudo apt-get install -y apt-transport-https && sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

	printf "\n»» deb kubernetes\n"
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update

	printf "\n»» Update and install kube*\n"
	sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubernetes-cni

	printf "\n»» Enable docker\n"
	systemctl enable docker.service
	
	printf "\n»» Initialize kubeadm\nWait about a minute please...\n"
	kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=`ip a|grep -oP "inet \K[0-9.]*(?=.*[^ ][^o]$)"` > kubeadm_join.txt # `ip a|grep -oP "inet \K[0-9.]*(?=.*[^ ][^o]$)"` 

	printf "\n»» Kube config\n"
	sudo cp /etc/kubernetes/admin.conf $HOME/
	sudo chown $(id -u):$(id -g) $HOME/admin.conf
	export KUBECONFIG=$HOME/admin.conf
	echo "export KUBECONFIG=$HOME/admin.conf" | tee -a ~/.bashrc

	echo "
»» Kube network config:\n"
	kubectl apply --filename https://git.io/weave-kube-1.6
	
}

function create_node(){
	printf "\n»» Update packages\n"
	sudo apt-get update -y

	printf "\n»» Install docker.io\n"
	sudo apt-get install -qy docker.io

	printf "\n»» Update packages, add gpg key\n"
	sudo apt-get update && sudo apt-get install -y apt-transport-https && sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

	printf "\n»» deb kubernetes\n"
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update

	printf "\n»» Update and install kube*\n"
	sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubernetes-cni

	printf "\n»» Enable docker\n"
	systemctl enable docker.service
	
	echo "
#############################################################################
# Important note: execute \"kubeadm join\" from master role in this terminal  #
#############################################################################"

}

function create_cluster_role() {

	if [ "$ROLE" == "node" ]; then
		create_node
	else
		create_master
	fi
}

ROLE=
IP=

while getopts ":u:r:i" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
	r)
      ROLE=${OPTARG}
      ;;
    i)
      IP=${OPTARG}
      ;;
    ?)
      usage
      exit
      ;;
    esac
done

if [[ -z $ROLE ]]; then
  usage
  exit 1
fi

create_cluster_role $ROLE $IP