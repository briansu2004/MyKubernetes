#!/bin/bash

# Deploy Network plugin
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml

# Create a namespace
kubectl create ns mynamespace
kubectl create ns staging
kubectl create ns prod


# Create Pods
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: test1
  namespace: mynamespace
spec:
  containers:
  - image: ubuntu
    name: test1
    command: ["sleep"]
    args: ["50000"]
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: test3
  namespace: mynamespace
spec:
  containers:
  - image: nginx
    name: test3
    resources:
      requests:
        memory: "64Mi"
        cpu: "0.3"
      limits:
        memory: "128Mi"
        cpu: "0.5"
EOF


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: test4
  namespace: mynamespace
spec:
  containers:
  - image: nginx
    name: test4
    resources:
      requests:
        memory: "4Mi"
        cpu: "0.3"
      limits:
        memory: "5Mi"
        cpu: "0.5"
EOF

# Create Service Account
kubectl -n default create sa test1
kubectl -n default create sa test2
kubectl -n default create sa test3


clear
echo "Please wait 15s for the environment setup..."
sleep 15s
echo ""
echo ""
echo "The test environment is ready! Please go to the quiz to start your test! Good luck!"
echo "Note: The quiz link should be sent to your email. Please contact Chance if you don't receive it. Thanks"
