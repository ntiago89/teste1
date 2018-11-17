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
sudo ./1st_kubeadm_cluster_as_root_user.sh -r master [-i 104.209.168.116]
-u                      : Display usage
-r [role]               : role = type of role wished: master or node (required)
-i [ip]                 : ip = Public IP of the machine
EOF
}

function create_master(){
	# First update packages

	echo "»» Update packages"
	sudo apt-get update -y

	echo "»» Install docker.io"
	sudo apt-get install -qy docker.io

	echo "»» Update packages, add gpg key"
	sudo apt-get update && sudo apt-get install -y apt-transport-https && sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

	echo "»» deb kubernetes"
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update

	echo "»» Update and install kube*"
	sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubernetes-cni

	echo "»» Enable docker"
	systemctl enable docker.service
	
	echo "»» Initialize kubeadm
Wait about a minute please..."
	kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=`ip a|grep -oP "inet \K[0-9.]*(?=.*[^ ][^o]$)"` > kubeadm_join.txt # `ip a|grep -oP "inet \K[0-9.]*(?=.*[^ ][^o]$)"` 
	echo "Execute the following command in node terminal, as said in \"Important note\" when you execute it:
	
	`tail -2 kubeadm_join.txt | head -1`
	
This command is also saved in kubeadm_join.txt file"
	
	echo "
****Now, without root user execute the 2nd_kubeadm_cluster_as_regular_user_only_for_master.sh****"

}

function create_node(){
	echo "»» Update packages"
	sudo apt-get update -y

	echo "»» Install docker.io"
	sudo apt-get install -qy docker.io

	echo "»» Update packages, add gpg key"
	sudo apt-get update && sudo apt-get install -y apt-transport-https && sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

	echo "»» deb kubernetes"
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update

	echo "»» Update and install kube*"
	sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubernetes-cni

	echo "»» Enable docker"
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