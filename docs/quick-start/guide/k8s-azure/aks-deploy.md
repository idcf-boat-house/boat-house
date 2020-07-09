# 在Azure上创建boathouse 运行所需的 K8s环境(使用使用脚本自动创建vmss的方式]

### 工具依赖
1. AZ CLI：用以连接 Azure China 。
    - 安装方式：[安装 Azure CLI](https://docs.microsoft.com/zh-cn/cli/azure/install-azure-cli?view=azure-cli-latest)
2. 安装[Kubectl集群管理工具](https://kubernetes.io/docs/tasks/tools/install-kubectl/) 

### 创建k8s

1. 打开并登陆azure 门户, 找到k8s服务，或直接打开*此链接*，点击添加。

![](images/6ebf45244c4ba2fd888936f4798ec45f.png)

2. 进入创建aks集群向导，其他选项都可按默认下一步，最后点击创建即可。

![](images/c4f68f554170519947c0263f105f74a2.png)

3.  等待创建成功，创建成功后可看到类似下图的资源 组：

![](images/3ed00e73a34a0c31d92a2c19816df776.png)

4.  执行以下命令获取k8s kube配置文件： 。执行前请登陆所属的订阅。
```
az cloud set --name AzureChinaCloud
az login -u [订阅帐号] -p [订阅密码]
az account set --subscription [订阅名称]
az aks get-credentials --resource-group [所属资源组] --name [k8s集群名称]
```

5. 运行命令测试本机是否可正常连接至k8s集群：`kubectl get pod -n kube-system`

```
NAME                                    READY   STATUS    RESTARTS   AGE
coredns-5fbb57454d-7pfqm                1/1     Running   0          20h
coredns-5fbb57454d-hbt4g                1/1     Running   0          20h
coredns-autoscaler-57fd48955f-zkcbq     1/1     Running   0          69m
kube-proxy-78pb8                        1/1     Running   0          68m
kube-proxy-8rwwj                        1/1     Running   0          68m
kubernetes-dashboard-74fd5f4c54-d5pp8   1/1     Running   0          20h
metrics-server-688fb4b5ff-6v75g         1/1     Running   0          20h
omsagent-7xdrf                          1/1     Running   0          69m
omsagent-dr5lg                          1/1     Running   0          68m
omsagent-rs-6bdfbd59cb-6hzmj            1/1     Running   0          69m
tunnelfront-7bc54b577f-8b4vs            1/1     Running   0          20h
```

6.  kube 配置文件获取成功后，执行以下命令获取配置文件，然后将config内容复制保存起来。
```
# 进入当前用户所在目录，win系统通常为 C:\Users\[account name]\
cat .kube\\config
```

7.  将上一步复制的内容保存起来，在接下来的Jenkins流水线和Github流水线中需要用到

