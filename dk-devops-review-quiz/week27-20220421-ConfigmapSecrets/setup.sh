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
  name: ubuntu-sleeper
  namespace: mynamespace
spec:
  containers:
  - image: ubuntu
    name: ubuntu-sleeper
    command: ["sleep"]
    args: ["5000"]
EOF

# Create ConfigMap
kubectl create configmap cmtest1 --from-literal=APP_NAME=red
kubectl create configmap cmtest2 --from-literal=APP_NAME=green
kubectl create configmap cmtest3 --from-literal=APP_NAME=blue

# Create Secrets
kubectl create secret generic test4-secret --from-literal=username=produser --from-literal=password=Y4nys7f11
kubectl create secret generic test5-db-secret --from-literal=username=produser --from-literal=password=Y4nys7f11

clear
echo "Please wait 15s for the environment setup..."
sleep 15s
echo ""
echo ""
echo "The test environment is ready! Please go to the quiz to start your test! Good luck!"
echo "Note: The quiz link should be sent to your email. Please contact Chance if you don't receive it. Thanks"
