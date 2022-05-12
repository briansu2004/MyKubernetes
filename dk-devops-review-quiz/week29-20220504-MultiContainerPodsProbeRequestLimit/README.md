# 准备步骤
1. 通过浏览器(Chrome/Firefox)**登入实验环境** [Kubernetes Playground](https://www.katacoda.com/courses/kubernetes/playground)

2. 点击"**START SCENARIO**"开启实验环境

3. 进入实验环境以后，**点击左侧“Launch Cluster”里的命令"launch.sh"**，Terminial Host1（右边上面的命令框）中就会在controlplane里初始化实验环境里的Kubernetes集群

4. 回到右边上面的Terminal Host1, 输入以下命令，**检查node01是否加入集群**
```
kubectl get nodes
```

5. **下载**测试环境setup脚本
```
git clone https://github.com/chance2021/dk-devops-review-quiz.git
```
6. **运行**测试环境setup脚本
```
cd dk-devops-review-quiz/week29-20220504-MultiContainerPodsProbeRequestLimit && \
bash setup.sh
```
7. **查看**所有测试Pods是否在Running状态，是的话就可以开始答题
```
kubectl get pods -n mynamespace
```
> Tip: You can use command `kubectl explain pods --recursive |less` to check the pod's YAML template
> Tip: 如有疑问，可以随时参考官方文档[点击这里](https://kubernetes.io/docs/concepts/)
