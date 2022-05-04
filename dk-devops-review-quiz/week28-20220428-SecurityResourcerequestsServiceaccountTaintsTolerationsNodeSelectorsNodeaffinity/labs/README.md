# 第二期K8s - 第二十八周 参考答案

## 1. What is the user used to execute the sleep process within the test1 pod in mynamespace?
> 注：这题考察的主要是如何登入Pod里的Container然后执行命令

**Hint:**
1. 登入Pod test1
```
kubectl exec -it test1 -n mynamespace -- bash
```
2. 运行一下命令查看User
```
whoami
```
## 2. Create a pod named test2 with user ID 1010 in mynamespace. Please use nginx as the image.
> 注：这题考察的是如何设置Pod里Container的用户

**Hint:**
```
apiVersion: v1
kind: Pod
metadata:
  name: test2
  namespace: mynamespace
spec:
  securityContext:
    runAsUser: 1010
  containers:
  -  image: ubuntu
     name: test2
     command: [ "sh","-c","sleep 5000" ]
```

## 3. Update pod test2 to run as Root user and with the SYS_TIME capability.
> 注： 这题考察的是如何设置Pod的Capability。注意，Pod可能无法直接编辑，可以把Pod删除，然后Apply修改过的Pod definition 文件

**Hint:**

```
apiVersion: v1
kind: Pod
metadata:
  name: test2
  namespace: mynamespace
spec:
  containers:
  - image: nginx
    name: test2
    securityContext:
      capabilities:
        add: ["SYS_TIME"]
```

## 4. A pod called test3 is deployed. What is the CPU requirements?
> 注：这题考察的是如何查看Pod里的CPU资源限制

**Hint:**

1. 运行以下命令，然后查找`Containers.test3.Requests.cpu`里的阈值
```
kubectl -n mynamespace describe pod test3
```

## 5. The pod test4 in mynamespace fails to get to a running state. Inspect this pod and identify the Reason why it is not running.   
> 注： 这题主要考察的是如何判断Pod的运行状态，并进行相应的Troubleshooting

**Hint:**

1. 运行以下命令查看Pod的运行状态
```
kubectl get pods -n mynamespace
```

## 6. Increase the limit of the test4 pod to 20Mi.Delete and recreate the pod if required. Do not modify anything other than the required fields.
> 注：这题考察的是如何设定/修改Pod的资源限制。这个操作在日常工作中很常见

1. 获取Pod test4的Definition YAML文件
```
kubectl get pods test4 -n mynamespace -o yaml > test4-pod.yaml
```
2. 修改`test4-pod.yaml`里`spec.containers.resources.limits.memory`值，改为`20Mi`

3. 删除Pod test4
```
kubectl delete pod test4
```
4. 重新部署Pod test4
```
kubectl apply -f test4-pod.yaml
```

## 7. How many Service Accounts exist in the default namespace?
> 注：这题考察的是如何查看某个Namespace里的Service Accounts总体情况，这和查看其他的API对象的方式都是一样

1. 运行以下命令查看default namespace里的Service account情况
```
kubectl get sa -n default
```
或者直接不带namespace（因为默认情况下kubeconfig里的namespace就是default，除非你手动修改了）
```
kubectl get sa
```
> 注：sa是service account的缩写

## 8. How many nodes exist on the system?
> 注：这题考察的是如何查看整个K8s cluster里的Node情况，这和查看其他的API对象的方式都是一样，不过由于Node是cluster级别，而不是namespace级别的API对象，所以查看的时候不需要带上namespace
1. 运行以下命令查看Cluster里的Node情况
```
kubectl get node
```
你还可以通过一下命令看到更多的信息
```
kubectl get nodes -o wide
```

## 9. Create a taint on node01 with key of spray, value of mortein and effect of NoSchedule
> 注：这题考察的是如何使用taint来保护Node
1. 运行以下命令来taint node01
```
kubectl taint nodes node01 spray=mortein:NoSchedule
```
这样node01就会被打上`spray=mortein`的标签。新创建的Pod,除非有相应的Toleration，否则无法被调度到node01上

## 10. Create a new pod test5 with the nginx image and pod name as mosquito in mynamespace. Check the status of the pod.
> 注：这题主要是验证一下上面一题的taint是否成功。如果成功，此时将没有符合要求的Node供新的Pod使用，Pod会一直处于`Pending`的状态
1. 运行以下命令来创建相应的Pod
```
kubectl run test5 --image=nginx -n mynamespace
```
2. 查看Pod test5的状态
```
kubectl get pods -n mynamespace
```

## 11. Create another pod named test6 with the nginx image in mynamespace, which has a toleration set to the taint mortein. Check the status of the pod.
> 注：这题主要考察的是如何创建一个Pod能够被调度到已经被taint的了node上

**Hint:**

1. Apply以下Pod definition yaml:

```
apiVersion: v1
kind: Pod
metadata:
  name: test6
  namespace: mynamespace
spec:
  containers:
  - name: test6
    image: nginx
  tolerations:
  - key: "spray"
    value: "mortein"
    operator: "Equal"
    effect: "NoSchedule"
```

## 12. Apply a label color=blue to node node01
> 注：这题考察的是如何给Node打标签Label

**Hint:**

1. 运行以下命令给Node01打Label
```
kubectl label node node01 color=blue
```

## 13. Create a new deployment named test6 with the nginx image and 2 replicas, and ensure it gets placed on the node1 only.
> 注：这题考察的是如何将Pod调度到指定Node上。这题必须在12题完成之后才能开始作答

**Hint:**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test7
  namespace: mynamespace
spec:
  replicas: 3
  selector:
    matchLabels:
      run: test7
  template:
    metadata:
      labels:
        run: test7
    spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: test7
      tolerations:
      - key: "spray"
        value: "mortein"
        operator: "Equal"
        effect: "NoSchedule" 
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: color
                operator: In
                values:
                - blue
```

运行以下命令查看Pod test7是否调度到了Node01上
```
kubectl get pods -n mynamespace  -o wide
```
