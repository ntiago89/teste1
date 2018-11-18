# Kubeadm launcher in Google Cloud Platform 

Repository of the course unit of Successful System in Production of MAPi.
This repo will be used to save a script related to a launcher of a cluster using kubeadm.

## Prerequisites

To do this tutorial make sure that you already have a Google Cloud Platform account correctly configured.

Everything else will be explained above.

### Running the tutorial

For the execution of the tutorial, using the script kubeadm_cluster.sh in the Google Cloud, we must create two Ubuntu instances: kubeadm-master and kubeadm-node.

After that, in the kubeadm-master instance the following commands can be executed, but always with root permissions.

- In **kubeadm-master**:
```
$ git clone https://github.com/nuno-t-simoes/SSP.git
$ cd SSP
$ sudo -s
# chmod + x kubeadm_cluster.sh
# source ./kubeadm_cluster.sh
$ sudo -s
# source ./kubeadm_cluster.sh -r master -i <Public IP of the machine in Google Cloud>
# tail -2 kubeadm_join.txt | head -1
```

- Copy kubeadm join and paste into kubeadm-node, as noted below. Kubeadm join saved to kubeadm_join.txt in the machine

- In **kubeadm-node**:
```
$ git clone https://github.com/nuno-t-simoes/SSP.git
$ cd SSP
$ sudo -s
# chmod +x kubeadm_cluster.sh
# ./kubeadm_cluster.sh -r node
```

- Paste the kubeadm join, from master, into the terminal.

- In **kubeadm-master**, again:
```
$ kubectl get pods --all-namespaces
$ kubectl get nodes
$ kubectl describe node <master node name>
```

**[1] Extra commands**:
```
$ kubectl get pods
$ kubectl get svc
$ kubectl get pods --all-namespaces -o=wide
	
$ kubectl run guids --image=alexellis2/guid-service:latest --port 9000
$ kubectl describe pod <name of pod>
$ kubectl describe pod <name of pod> | grep IP:
$ curl http://<IP of pod>:9000/guid
```

**[2] Extra commands**:
```
$ kubectl run helloworld --image=karthequian/helloworld --port=80
$ kubectl get pods
$ kubectl get svc
$ kubectl expose deployment helloworld --type=NodePort
```

In other shell:
```
$ curl <Pod’s IP>:<Port>
```

## Contributing

The script is based in two links:
- [oom_rancher_setup](https://github.com/onap/logging-analytics/blob/master/deploy/rancher/oom_rancher_setup.sh)
- [Setup Kubernetes Cluster locally on Ubuntu by IT Markaz](https://www.youtube.com/watch?v=6ZRphF0wGAM)

A possible execution is available here: (https://youtu.be/dDRNWxHsi8Y)


## Authors

* **Nuno Simões** - *Initial work* - [SSP - kubeadm](https://github.com/nuno-t-simoes/SSP.git)
