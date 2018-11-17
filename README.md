SSP Repository
======

Repository of the course unit of Successful System in Production of MAPi.
This repo will be used to save a script related to a launcher of a cluster using kubeadm.

These are the requirements to use these scripts:
- 1st: as root user execute the script "kubeadm_cluster_root_user.sh" using the following examples -> sudo ./kubeadm_cluster.sh -r master [-i 104.209.168.116]
- 2nd: as regular user (ctrl+d ou exit after done the 1st step) in the end of the execution of script of 1st step, execute the script "kubeadm_cluster_regular_user_for_master.sh".