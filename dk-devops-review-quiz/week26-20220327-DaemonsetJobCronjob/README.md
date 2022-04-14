# 准备步骤
1. 通过浏览器(Chrome/Firefox)**登入实验环境** [Kubernetes Playground](https://www.katacoda.com/courses/kubernetes/playground)

2. 点击"**START SCENARIO**"开启实验环境

3. 进入实验环境以后，**点击左侧“Launch Cluster”里的命令"launch.sh"**，Terminial Host1（右边上面的命令框）中就会在controlplane里初始化实验环境里的Kubernetes集群

4. 回到右边上面的Terminal Host1, 输入以下命令，**检查node01是否加入集群**
```
kubectl get nodes
```

5. 打印**Join token**, 然后Copy & Paste到node01中，将node01加入到Cluster里
```
kubeadm token create  --print-join-command
```

6. **下载**测试环境setup脚本
```
git clone https://github.com/chance2021/dk-devops-review-quiz.git
```
7. **运行**测试环境setup脚本
```
cd dk-devops-review-quiz/week26-20220327-DaemonsetJobCronjob && \
bash setup.sh
```
8. **查看**所有测试Pods是否在Running状态，是的话就可以开始答题
```
kubectl get pods -n mynamespace
```
