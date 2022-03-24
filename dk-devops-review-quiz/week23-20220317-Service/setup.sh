#!/bin/bash

# Deploy Network plugin
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml

# Create a namespace
kubectl create ns mynamespace

# Create Pods
kubectl run test1 --image=nginx -n mynamespace
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: test2
  name: test2
  namespace: mynamespace
spec:
  containers:
  - image: nginx2
    name: test2
  - image: hello-world
    name: test2-1
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: test3
    type: ssd
  name: test3
  namespace: mynamespace
spec:
  containers:
  - image: redis
    name: test3
  - image: nginx
    name: test3-2
EOF
kubectl expose pod test3 --target-port=6379 --port=80 -n mynamespace
kubectl run test4 --image=redis123 -n mynamespace
kubectl run test5 --image=hello-world -n mynamespace
kubectl run test6 --image=centos8 -n mynamespace
kubectl create deployment test7 --image=redis -n mynamespace
kubectl create deployment test8 --image=nginx -n mynamespace
kubectl scale deployment test7 --replicas=3 -n mynamespace

clear
echo "Please wait 15s for the environment setup..."
sleep 15s
echo ""
echo ""
echo "The test environment is ready! Please go to the quiz to start your test! Good luck!"
echo "Note: The quiz link should be sent to your email. Please contact Chance if you don't receive it. Thanks"
