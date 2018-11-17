SSP Repository
======

Repository of the course unit of Successful System in Production of MAPi.
This repo will be used to save a script related to a launcher of a cluster using kubeadm.

These are the requirements to use these scripts:
- 1st: as root user execute the script "source ./kubeadm_cluster.sh" using the following examples -> source ./kubeadm_cluster.sh -r master [-i 104.209.168.116]
- 2nd: in node point execute the  script usually -> ./kubeadm_cluster.sh -r node

### Installing

To install kubeadm and is requirements, you must execute the following command as a root user for master:

```
./kubeadm_cluster.sh -r master [-i <IP of the machine>]
```

or for node:

```
./kubeadm_cluster.sh -r node
```
