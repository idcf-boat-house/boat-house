## 0. 基础准备：

1. 打开Azure门户并登录账号
2. 打开命令行窗口操作生产环境集群
3. 连接到k8s master命令行创建demo新的集群部署
```shell
kubectl delete secret regcred -n boathouse-test
kubectl delete secret regcred -n boathouse-prod
kubectl delete namespace boathouse-test
kubectl delete namespace boathouse-prod
```



## 1. 基于Azure的Kubernetes集群创建

##### 1.1 ASK创建 

1. 登录Portal - 点击创建资源 - 选择Kubernetes Service
Portal：https://portal.azure.com/
订阅：Visual Studio Ultimate

2. 特性：自动升级、节点缩放、Master节点不需要维护

##### 1.2 使用aks-engine创建

aks-engine介绍：
https://github.com/Azure/aks-engine/blob/master/docs/tutorials/quickstart.zh-CN.md

集群定义文件介绍：template-tool-config.json
https://github.com/Azure/aks-engine/blob/master/docs/topics/clusterdefinitions.zh-CN.md

生成后的模版文件介绍：

1. apimodel.json - 集群配置文件（版本、ImageBase、插件）
2. azuredeploy.json - 核心的ARM (Azure Resource Model)模板，用来部署Docker集群
3. azuredeploy.parameters.json - 部署参数文件，其中的参数可以自定义

创建环境：

集群搭建文档：https://github.com/idcf-boat-house/boat-house-devops/blob/master/docs/Azure%E5%BF%AB%E9%80%9F%E6%90%AD%E5%BB%BAK8s%E7%8E%AF%E5%A2%83/Azure%E5%BF%AB%E9%80%9F%E6%90%AD%E5%BB%BAK8s%E7%8E%AF%E5%A2%83.md

K8s创建命令
```shell
.\env-generator.ps1 -AzureUserName [username] -AzureUserPwd [Password] -SubscriptionName [subName] -AzureSPApplicationId [id] -AzureSPApplicationKey [key]
```

已存在K8s环境：ssh localadmin@[ip]


## 2. Kubernetes架构 && Boathouse部署介绍

##### 2.1 高可用性、VMSS（Virtual Machine Scale Set）


##### 2.2 Boathouse部署介绍（命名空间、密钥、外网访问服务、数据持久化）

查看命名空间、查看密钥


```shell
kubectl get namespaces
kubectl get secret -n boathouse-test

```


##### 2.3 Deployment介绍 （Deployment、ReplicaSet、Pod、Node关系），Yaml文件解析

查看Node节点、查看Deployment资源对象、查看ReplicaSet资源对象、查看Pod资源对象与Node的关系

```shell
kubectl get nodes -n boathouse-test -o wide
kubectl get deployment -n boathouse-test -o wide
kubectl get rs -n boathouse-test
kubectl get pods -n boathouse-test  -o wide

```


##### 2.4 Servie介绍（几种模式clusterIp、NodePort、LoadBalancer、Ingress）

解析YAML文件内容、查看Service负载均衡对应的EndPoint、比较Pod与Service：

查看Service：

```shell
kubectl get service -n boathouse-test
kubectl describe service client -n boathouse-test
kubectl get pods -o wide
```


登录Portal查看对应的Azure创建的LoadBalancer以及Public Id


##### 2.5 动态创建持久化存储介绍

解析PVC YAML文件内容

查看预定义的SC、查看Provisioner、查看PVC、查看PV、查看PV绑定的Disk

```shell
kubectl get sc
kubectl get sc default -o yaml
kubectl get pvc -n boathouse-test
kubectl get pv
kubectl get pv [pvc-name] -n boathouse-test -o yaml

```


## 3. Jenkins流水线部署

##### 3.1 集群环境初始化：

1.创建命名空间：

```shell
kubectl create namespace boathouse-test
kubectl create namespace boathouse-prod
```

2.创建docker-registry-secrets

```shell
kubectl create secret docker-registry regcred --docker-server=docker.pkg.github.com --docker-username=[username] --docker-password=[password] --docker-email=info@idcf.io -n boathouse-test

kubectl create secret docker-registry regcred --docker-server=docker.pkg.github.com --docker-username=[username] --docker-password=[password] --docker-email=info@idcf.io -n boathouse-prod
```

##### 3.2 更新镜像组织名称docker-compose-template.yaml && Kompose

##### 3.3 安装Kubernets Continuous Deploy插件
Jenkins地址：http://jenkins.devopshub.cn/
插件地址：https://plugins.jenkins.io/kubernetes-cd/

##### 3.4 添加Kubeconfig凭据


##### 3.5 生成集群部署Pipeline脚本：经典模式 - 流水线配置 - Pipeline Syntax


##### 3.6 添加脚本到Jenkinsfile中

测试环境

```
kubernetesDeploy configs: 'kompose/test/client-deployment.yaml,kompose/test/management-deployment.yaml,kompose/test/product-service-api-deployment.yaml,kompose/test/statistics-service-api-deployment.yaml,kompose/test/statistics-service-worker-deployment.yaml', deleteResource: true, kubeConfig: [path: ''], kubeconfigId: 'creds-test-k8s', secretName: 'regcred', secretNamespace: 'boathouse-dev', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']


kubernetesDeploy configs: 'kompose/test/*', deleteResource: false, kubeConfig: [path: ''], kubeconfigId: 'creds-test-k8s', secretName: 'regcred', secretNamespace: 'boathouse-dev', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
```

生产环境

```
kubernetesDeploy configs: 'kompose/prod/client-deployment.yaml,kompose/prod/management-deployment.yaml,kompose/prod/product-service-api-deployment.yaml,kompose/prod/statistics-service-api-deployment.yaml,kompose/prod/statistics-service-worker-deployment.yaml', deleteResource: true, kubeConfig: [path: ''], kubeconfigId: 'creds-test-k8s', secretName: 'regcred', secretNamespace: 'boathouse-prod', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']


kubernetesDeploy configs: 'kompose/prod/*', deleteResource: false, kubeConfig: [path: ''], kubeconfigId: 'creds-test-k8s', secretName: 'regcred', secretNamespace: 'boathouse-prod', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
```


## 4. NextPlan

- 有状态应用 && 无头服务
- 集群监控方案（CAdvisor、Heapster、Infulexdb、Grafana）
- 统一日志方案（ELK）
- 灰度发布（ISTIO）

## 5. 问题答疑


