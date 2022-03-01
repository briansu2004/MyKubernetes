# Kubernetes Cluster Setup

1. Ensure network setting is configured in the master node:
```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
```

2. Install docker/kubectl/kubelet/kubeadm in the master node
```
sudo apt-get update && \
sudo apt-get install -y apt-transport-https ca-certificates curl && \
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update && \
sudo apt-get install -y kubelet kubeadm kubectl docker.io && \
sudo apt-mark hold kubelet kubeadm kubectl 
```

3. Configure the Docker daemon in the master node
```
cat <<EOF | sudo tee /etc/docker/daemon.json 
{ 
  "exec-opts": ["native.cgroupdriver=systemd"], 
  "log-driver": "json-file", 
  "log-opts": { 
    "max-size": "100m" 
  }, 
  "storage-driver": "overlay2" 
} 
EOF

sudo systemctl daemon-reload && \
sudo systemctl restart kubelet && \
sudo systemctl start kubelet && \
sudo systemctl start docker 

sudo docker info|grep systemd

sudo systemctl status kubelet 

sudo systemctl status docker
```

4. Initiate kube cluster
```
ifconfig |grep -A 1 eth0|grep inet|awk '{print $2}'|sed '/^$/d' # Checking the ip

sudo swapoff -a && \
sudo kubeadm init --apiserver-advertise-address=`ifconfig |grep -A 1 eth0|grep inet|awk '{print $2}'|sed '/^$/d'`  --pod-network-cidr=10.244.0.0/16 && \
mkdir -p $HOME/.kube && \
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && \
sudo chown $(id -u):$(id -g) $HOME/.kube/config
``` 
  
5. Deploy network plugin
```
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml
```

6. Install docker/kubectl/kubelet/kubeadm in worker node
```
# ssh to the worker nodes and run below commands

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo apt-get update && \
sudo apt-get install -y apt-transport-https ca-certificates curl && \
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update && \
sudo apt-get install -y kubelet kubeadm kubectl docker.io && \
sudo apt-mark hold kubelet kubeadm kubectl 

# Set up the Docker daemon 

cat <<EOF | sudo tee /etc/docker/daemon.json 
{ 
  "exec-opts": ["native.cgroupdriver=systemd"], 
  "log-driver": "json-file", 
  "log-opts": { 
    "max-size": "100m" 
  }, 
  "storage-driver": "overlay2" 
} 
EOF

sudo systemctl daemon-reload && \
sudo systemctl restart kubelet && \
sudo systemctl start kubelet && \
sudo systemctl start docker 

sudo docker info|grep systemd
sudo systemctl status kubelet 
sudo systemctl status docker
```

7. Run the join token gotten from the master node in the worker node to join the worker node to the cluster
```
# Running in master node
kubeadm token create --print-join-command

# Running in worker node
sudo kubeadm join 10.168.0.2:6443 --token <token> --discovery-token-ca-cert-hash <token>
```

8. Setup a NFS server
```
sudo apt-get update && \
sudo apt install nfs-kernel-server -y && \
sudo mkdir /mnt/myshareddir && \
sudo chown nobody:nogroup /mnt/myshareddir #no-one is owner && \
sudo chmod 777 /mnt/myshareddir #everyone can modify files

sudo vi /etc/exports
/mnt/myshareddir {clientIP}(rw,sync,no_subtree_check)

sudo exportfs -a #making the file share available && \
sudo systemctl restart nfs-kernel-server #restarting the NFS kernel

```

9. (Unfinished) Install nfs provider
```
# Method 1: Install Helm
sudo apt install gnupg gnupg2 gnupg1 -y && \
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add - && \
sudo apt-get install apt-transport-https --yes  && \
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list  && \
sudo apt-get update  && \
sudo apt-get install helm
kubectl create ns nfs-provisioner
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \ 
            --set nfs.server=192.168.1.152 \ 
            --set nfs.path=/srv/nfs/kubedata 
            
# Method 2: Apply  nfs-subdir-external-provisioner manifest (kubectl apply -f <below yaml file>)

NFS_IP=<Need to replace with NFS server IP>
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: nfs-client
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-client-provisioner
  labels:
    app: nfs-client-provisioner
  namespace: nfs-client
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nfs-client-provisioner
  template:
    metadata:
      labels:
        app: nfs-client-provisioner
    spec:
      serviceAccountName: nfs-client-provisioner
      containers:
        - name: nfs-client-provisioner
          image: quay.io/external_storage/nfs-client-provisioner:v3.1.0-k8s1.11
          volumeMounts:
            - name: nfs-client-root
              mountPath: /persistentvolumes
          env:
            - name: PROVISIONER_NAME
              value: nfs-provisioner
            - name: NFS_SERVER
              value: $NFS_IP
            - name: NFS_PATH
              value: /mnt/nfs
      volumes:
        - name: nfs-client-root
          nfs:
            server: $NFS_IP
            path: /mnt/nfs
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: managed-nfs-storage
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: nfs-provisioner
parameters:
  archiveOnDelete: "false"
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nfs-client-provisioner
  namespace: nfs-client
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-client-provisioner-runner
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "update", "patch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: run-nfs-client-provisioner
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    namespace: nfs-client
roleRef:
  kind: ClusterRole
  name: nfs-client-provisioner-runner
  apiGroup: rbac.authorization.k8s.io
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  namespace: nfs-client
rules:
  - apiGroups: [""]
    resources: ["endpoints"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  namespace: nfs-client
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    namespace: nfs-client
roleRef:
  kind: Role
  name: leader-locking-nfs-client-provisioner
  apiGroup: rbac.authorization.k8s.io        
  
EOF
```

10. Deploy K8s dashboard
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc6/aio/deploy/recommended.yaml
```

---
# Troubleshooting

## Issue 1:
Kubelet cannot start
```
sudo journalctl -a |grep kubelet
Feb 17 06:51:24 node01 kubelet[19960]: E0217 06:51:24.709567   19960 server.go:302] "Failed to run kubelet" err="failed to run Kubelet: misconfiguration: kubelet cgroup driver: \"systemd\" is different from docker cgroup driver: \"cgroupfs\""
```

### Solution:
Make sure you have updated daemon.json as below configuration
```
cat <<EOF | sudo tee /etc/docker/daemon.json 
{ 
  "exec-opts": ["native.cgroupdriver=systemd"], 
  "log-driver": "json-file", 
  "log-opts": { 
    "max-size": "100m" 
  }, 
  "storage-driver": "overlay2" 
} 
EOF


sudo docker info|grep system
WARNING: No swap limit support
  Backing Filesystem: extfs
 Cgroup Driver: systemd
````
