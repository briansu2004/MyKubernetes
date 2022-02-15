# MyKubernetes

My Kubernetes


## 2022-02-10

<details>

https://docs.google.com/forms/d/e/1FAIpQLScBSHWlre-Zl5uEx5SpWQftefvQt_sJhFWvQvV2LOeoZrEJ3Q/viewform?vc=0&c=0&w=1&flr=0

->

https://docs.google.com/forms/d/e/1FAIpQLScBSHWlre-Zl5uEx5SpWQftefvQt_sJhFWvQvV2LOeoZrEJ3Q/viewscore?viewscore=AE0zAgBOpgVaLkdMc83-L5-58dvCY_AbOHtb1nJw11SvXkTmjaW4I0yN267DzzD_Qv5le3A


## Ref

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

</details>

