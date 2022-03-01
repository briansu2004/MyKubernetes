# MyKubernetes

My Kubernetes

## URLs

GitHub

https://github.com/chance2021/dk-devops-review-quiz

Attendance

https://docs.google.com/spreadsheets/d/1ycnDY6OF1UFTYxSq2lWlQo0y-g6Ozko1KRAQysBQOPg/edit#gid=0

## Week 1/18, 2022-02-10

https://docs.google.com/forms/d/e/1FAIpQLScBSHWlre-Zl5uEx5SpWQftefvQt_sJhFWvQvV2LOeoZrEJ3Q/viewform?vc=0&c=0&w=1&flr=0

->

https://docs.google.com/forms/d/e/1FAIpQLScBSHWlre-Zl5uEx5SpWQftefvQt_sJhFWvQvV2LOeoZrEJ3Q/viewscore?viewscore=AE0zAgBOpgVaLkdMc83-L5-58dvCY_AbOHtb1nJw11SvXkTmjaW4I0yN267DzzD_Qv5le3A

https://kubernetes.io/docs/concepts/overview/components/

![](image/README/kubernetes_cluste_components.png)

Control Plane Components

- kube-apiserver
- etcd
- kube-scheduler
- kube-controller-manager
- cloud-controller-manager

Node Components

- kubelet
- kube-proxy
- Container runtime

kubectl translates your imperative command into a declarative Kubernetes Deployment object.

There are two basic ways to deploy to Kubernetes: imperatively, with the many kubectl commands, or declaratively, by writing manifests and using `kubectl apply`.

How to deploy a database on Kubernetes

Now, let’s dive into more details on how to deploy a database on Kubernetes using StatefulSets. With a StatefulSet, your data can be stored on persistent volumes, decoupling the database application from the persistent storage, so when a pod (such as the database application) is recreated, all the data is still there. Additionally, when a pod is recreated in a StatefulSet, it keeps the same name, so you have a consistent endpoint to connect to. Persistent data and consistent naming are two of the largest benefits of StatefulSets. You can check out the Kubernetes documentation for more details.

![](image/README/20220210_01.png)

![](image/README/20220210_02.png)

![](image/README/20220210_03.png)

## Week 2/19, 2022-02-17

https://docs.google.com/forms/d/e/1FAIpQLSeSrGJTolsj2dO8Q-Xu0uKn1QW3Dr9QHw0vVEjhxTa-sWsLiA/viewform?vc=0&c=0&w=1&flr=0

->

https://docs.google.com/forms/d/e/1FAIpQLSeSrGJTolsj2dO8Q-Xu0uKn1QW3Dr9QHw0vVEjhxTa-sWsLiA/viewscore?viewscore=AE0zAgBLjjH1i67JJiUBIuaqLGzzgkAsGQe8dpkWMo_Qk5dZBzzfw3VER7ixsYmigHiGw0s

![](image/README/20220217_01.png)

## Week 3/20, 2022-02-24

https://docs.google.com/forms/d/e/1FAIpQLSdWy73MttPztC5Hrgohfnpxr4FPUbP45rGue68awceeW_kTxg/viewform?vc=0&c=0&w=1&flr=0

->

https://docs.google.com/forms/d/e/1FAIpQLSdWy73MttPztC5Hrgohfnpxr4FPUbP45rGue68awceeW_kTxg/viewscore?viewscore=AE0zAgDRKfsIMMH99WMqsY6-pYNs2L5Qwo5Vicv08Qp9Ugl6TULY9sqDCfDjuVLmzzvz5vI

Kubernetes Playground

https://www.katacoda.com/courses/kubernetes/playground

https://www.katacoda.com/courses/kubernetes/getting-started-with-kubeadm

```
kubeadm init --token=102952.1a7dd4cc8d1f4cc5 --kubernetes-version $(kubeadm version -o short)
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
kubeadm join 172.17.0.89:6443 --token ztdjrf.rjqmz9tkgxbj2wd7     --discovery-token-ca-cert-hash sha256:3ca84e1f403d11b80f514ac2d8019c7e238952c6b274b5b08f735fbd4671c792
kubectl get nodes
```

![](image/README/week20_lab_01.png)

Within a Pod, containers share an IP address and port space, and can find each other via localhost . The containers in a Pod can also communicate with each other using standard inter-process communications like SystemV semaphores or POSIX shared memory.

Containers within same pod share network namespace and IPC namespace but they have separate mount namespace and filesystem.

Node Pod

A Pod always runs on a Node. A Node is a worker machine in Kubernetes and may be either a virtual or a physical machine, depending on the cluster. Each Node is managed by the control plane.

What is cluster node and pod?

Cluster. A cluster consists of one master machine and multiple worker machines or nodes. The master coordinates between all the nodes. Pod. A pod is the smallest unit of a cluster.

```
controlplane $ kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}"
k8s.gcr.io/coredns:1.3.1
k8s.gcr.io/coredns:1.3.1
k8s.gcr.io/etcd:3.3.10
k8s.gcr.io/kube-apiserver:v1.14.0
k8s.gcr.io/kube-controller-manager:v1.14.0
k8s.gcr.io/kube-proxy:v1.14.0
k8s.gcr.io/kube-proxy:v1.14.0
k8s.gcr.io/kube-scheduler:v1.14.0
weaveworks/weave-kube:2.8.1
weaveworks/weave-npc:2.8.1
weaveworks/weave-kube:2.8.1
weaveworks/weave-npc:2.8.1
nginx
nginx2
redis
redis123
```

```
controlplane $ kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{containers[*]}{.image}{", "}{end}{end}' | sort

coredns-fb8b8dccf-8wf72:        k8s.gcr.io/coredns:1.3.1,
coredns-fb8b8dccf-9xf5w:        k8s.gcr.io/coredns:1.3.1,
etcd-controlplane:      k8s.gcr.io/etcd:3.3.10,
kube-apiserver-controlplane:    k8s.gcr.io/kube-apiserver:v1.14.0,
kube-controller-manager-controlplane:   k8s.gcr.io/kube-controller-manager:v1.14.0,
kube-proxy-d8695:       k8s.gcr.io/kube-proxy:v1.14.0,
kube-proxy-gs9rq:       k8s.gcr.io/kube-proxy:v1.14.0,
kube-scheduler-controlplane:    k8s.gcr.io/kube-scheduler:v1.14.0,
test1-7687c59456-nm6bb: nginx,
test2-f86cb7678-mbqzq:  nginx2,
test3-78ff9dcdc7-kmfq8: redis,
test4-6dc9786c67-rxv7w: redis123,
weave-net-h895d:        weaveworks/weave-kube:2.8.1, weaveworks/weave-npc:2.8.1,
weave-net-s72t6:        weaveworks/weave-kube:2.8.1, weaveworks/weave-npc:2.8.1,
```

```
#!/bin/bash

# Deploy Network plugin
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml

# Create a namespace
kubectl create ns mynamespace

# Create Pods
kubectl run test1 --image=nginx -n mynamespace
kubectl run test2 --image=nginx2 -n mynamespace
kubectl run test3 --image=redis -n mynamespace
kubectl run test4 --image=redis123 -n mynamespace

clear
echo "Please wait 15s for the environment setup..."
sleep 15s
echo ""
echo ""
```

```
kubectl run test5 --image=nginx -n mynamespace
```

???

```
kubectl -n mynamespace run test5 --image nginx
```

![](image/README/week20_01.png)

![](image/README/week20_02.png)

![](image/README/week20_03.png)

## Week 4/21, 2022-03-03

???

## Ref
