# 第二期K8s - 第二十九周 参考答案

## 1. Identify the number of containers created in the red pod.
> 注：这题考察的是如何观察一个Pod里的详细信息，包括有多少个Containers

**Hint:**

运行`kubectl -n mynamespace describe pods red`,然后观察`container`区域里有多少个container. 这里应该能看到3个containers,分别是：apple, wine, scarlet

## 2. 常见的Multi-Container Pod Design Patterns有哪些？
> 注：这题考察的是对Multi-Container Pod design patterns的了解

**Hint:**
应该选择Sidecar,Adapter, Ambassador

## 3. Use the spec given below to create a multi-container pod with 2 containers.Pod name: yellow, Namespace: mynamespace, Container 1 Name: lemon, Container 1 Image: busybox, Container 1 Command line: sleep 1000; Container 2 Name: gold, Container 2 Image: redis
> 注：这题考察的是如何在一个Pod里创建多个containers

**Hint:**
运行以下命令
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: yellow
  namespace: mynamespace
spec:
  containers:
  - name: lemon
    image: busybox
    command: ["sleep", "1000"]
  - name: gold
    image: redis
EOF
```

## 4. Edit pod yellow to mount all containers to the same volume (hostPath to /var/log)
> 注：这题考察的是如何将Pod mount到指定Volume上

1. 删除Pod yellow
```
kubectl -n mynamespace delete pod yellow
```

2. 运行以下命令
```
cat <<EOF | kubectl apply -f - 
apiVersion: v1
kind: Pod
metadata:
  name: yellow
  namespace: mynamespace
spec:
  containers:
  - name: lemon
    image: busybox
    command: ["sleep", "1000"]
    volumeMounts:
    - mountPath: /log
      name: log-volume
  - name: gold
    image: redis
    volumeMounts:
    - mountPath: /log
      name: log-volume
  volumes:
  - name: log-volume
    hostPath:
      # directory location on host
      path: /var/log
      # this field is optional
      type: DirectoryOrCreate
EOF
```

## 6. Create a pod 'blue' with a readinessProbe using the given spec. Pod Name: blue, Image Name: kodekloud/webapp-delayed-start, Readiness Probe: httpGet, Http Probe: /ready, Http Port: 8080
> 注：这题考察的是如果使用readinessProbe

**Hint:**
运行以下命令
```
cat <<EOF |kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: blue
  namespace: mynamespace
spec:
  containers:
  - image: kodekloud/webapp-delayed-start
    name: simple-webapp
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
EOF
```
## 7. We have deployed a number of PODs in mynamespace. They are labelled with tier, env and bu. How many PODs exist in the dev environment (env)?
> 注：这题考察的是如何通过标签(label)来筛选Pod

**Hint:**
运行以下命令，筛选出环境是dev的Pod
```
kubectl -n mynamespace get pods -l env=dev
```

可以看到只有test3和test4 Pod符合标准,所以答案选**2**个Pod

## 8. How many objects are in bu=IT including PODs, ReplicaSets and any other objects?
> 注：这题考察的和上一题基本类似，只是需要从包括Pods在内的其他objects里进行筛选

**Hint:**
运行以下命令，筛选出bu是IT的所有objects
```
kubectl -n mynamespace get all -l bu=IT
```
可以看到只有test3,test4,test5 Pod符合标准,所以答案选**3**个Pod


## 9. Identify the node that consumes the most CPU.
> 注：这题考察的是如何观察node的资源使用情况

**Hint:**
运行以下命令查看node的资源使用情况
```
kubectl top node
```

如果运行命令的时候遇到报错`Error from server (NotFound): the server could not find the requested resource (get services http:heapster:)`, 说明集群中没有安装metrics监控组件，你可以运行以下命令安装组件：
```
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
cd kubernetes-metrics-server
kubectl create -f .
```
确保所有监控Pod正常运行之后，再运行一下上面的命令,你会发现`controlplane`占用了最多CPU资源


## 10. Identify the POD in mynamespace that consumes the most Memory.
> 注：这题考察的是如何观察pod的资源使用情况

**Hint:**
运行以下命令查看pod的资源使用情况
```
kubectl -n mynamespace top pod
```
Pod **blue**应该是消耗Memory最多的Pod
