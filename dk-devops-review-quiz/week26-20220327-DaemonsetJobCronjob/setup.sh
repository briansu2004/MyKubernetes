#!/bin/bash

# Deploy Network plugin
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml

# Create a namespace
kubectl create ns mynamespace
kubectl create ns staging
kubectl create ns prod


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
kubectl run blue --image=nginx -n prod
kubectl run db-service --image=postgres -n prod
kubectl expose pod db-service -n prod --port=5432 --target-port=5432
kubectl run db-service --image=postgres -n staging
kubectl expose pod db-service -n staging --port=5432 --target-port=5432
kubectl create deployment test7 --image=redis -n mynamespace
kubectl create deployment test8 --image=nginx -n mynamespace
kubectl scale deployment test7 --replicas=3 -n mynamespace

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: test9
  namespace: mynamespace
  labels:
    app: test9
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: test9
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: test9
  namespace: mynamespace
spec:
  selector:
    matchLabels:
      app: test9 
  serviceName: "test9"
  replicas: 3 # by default is 1
  template:
    metadata:
      labels:
        app: test9
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: test
        image: k8s.gcr.io/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
EOF


cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd-elasticsearch
  namespace: kube-system
  labels:
    k8s-app: fluentd-logging
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      tolerations:
      # this toleration is to have the daemonset runnable on master nodes
      # remove it if your masters can't run pods
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      containers:
      - name: fluentd-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
      terminationGracePeriodSeconds: 30
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
EOF

clear
echo "Please wait 15s for the environment setup..."
sleep 15s
echo ""
echo ""
echo "The test environment is ready! Please go to the quiz to start your test! Good luck!"
echo "Note: The quiz link should be sent to your email. Please contact Chance if you don't receive it. Thanks"
