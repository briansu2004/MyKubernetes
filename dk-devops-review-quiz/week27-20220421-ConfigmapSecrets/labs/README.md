# Lab 1: Create your first CronJob

1. Create a **bash script** as below:
```
cat > healthcheck.sh <<EOF
#!/bin/bash
nc -zv www.google.ca 443
if [ $? == 0 ]; then
    echo succeeded
else
    echo failed
fi
EOF
```

2. Create a **ConfigMap** in **default** namespace based on the file `healthcheck.sh` which is created in **Step 1**:
```
kubectl create configmap healthcheck -n default --from-file=healthcheck.sh
```

3. Create a **CronJob definition file** as below:
```
cat > healthcheck-cronjob.yaml <<EOF
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: healthcheck
  namespace: default
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: healthcheck
            image: praqma/network-multitool
            imagePullPolicy: IfNotPresent
            volumeMounts:
            - name: script-volume
              mountPath: /tmp/              
            command:
            - /bin/sh
            - -c
            - /tmp/healthcheck.sh
          restartPolicy: Never
          volumes:
            - name: script-volume
              configMap:
                name: healthcheck
                defaultMode: 0777
EOF
```

And **apply** the cronjob object:

```
kubectl apply -f healthcheck-cronjob.yaml
```

4. To **verify**, wait for another minute and check if the pod is completed successfully. If so, **check the log** to see if the output is expected (should be showing "succeeded").
```
kubectl -n default logs -f healthcheck-????
```
