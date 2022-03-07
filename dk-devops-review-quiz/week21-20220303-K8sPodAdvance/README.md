# 准备步骤
1. 通过浏览器(Chrome/Firefox)**登入实验环境** [Kubernetes Playground](https://www.katacoda.com/courses/kubernetes/getting-started-with-kubeadm)
2. 点击"**START SCENARIO**"开启实验环境
3. 进入实验环境以后，**点击左侧“Task”里第一个命令行黑框"kubeadm init --token..."的命令**，Terminial Host1（右边上面的命令框）中就会在controlplane里初始化实验环境里的Kubernetes集群
4. Kubernetes集群初始化完成后，**再点击左边“Task”里最下面的一个命令框"sudo cp ..."的命令**，这一步是设置controlplane中访问权限，设置完以后就可以使用kubectl命令和集群里的apiserver通信
5. 在右边上面的Terminal Host1里输入以下命令，**生成加入该集群的token**
```
kubeadm token create --print-join-command
```
6. 拷贝以上token命令“kubeadm join 172.17.0.37:6443 --token.....”，跳到右边下面的Terminal Host2里，**黏贴token命令，并且运行**。
7. 回到右边上面的Terminal Host1, 输入以下命令，**检查node01是否加入集群**
```
kubectl get nodes
```
8. **下载**测试环境setup脚本
```
git clone https://github.com/chance2021/dk-devops-review-quiz.git
```
9. **运行**测试环境setup脚本
```
cd dk-devops-review-quiz/week21-20220303-K8sPodAdvance && \
bash setup.sh
```
10. **查看**所有测试Pods是否在Running状态，是的话就可以开始答题
```
kubectl get pods -n mynamespace
```
