### Boat House K8S (Test & Prod) 环境部署


在前面的文档中，我们已经部署好 Jenkins 的流水线，并成功的部署了 Boat House 的 Dev 环境。
接下来，我们会使用已分配给团队的K8S环境部署 Boat House 的 Test & Prod 环境.

#### 配置 K8s 集群 & Jenkins 凭据

前提条件：安装Kubectl工具：

下载完成后参考下面链接的命令完成kubectl工具的安装：

https://kubernetes.io/docs/tasks/tools/install-kubectl/

Windows：下载kubectl.exe, 完成后配置环境变量PATH

下载地址: https://dl.k8s.io/release/v1.21.0/bin/windows/amd64/kubectl.exe

MacOS/Linux: 下载并解压，执行以下命令完成配置

```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

注意：如果以上安装地址出现无法访问的情况，请通过【Boathouse资源网盘】下载kubectl工具，下载方式如下

获取方式：扫描二维码，关注DevOps公众号，输入：boathouse训练营 即可获取网盘连接和密码

![](images/devops-barcode.jpg)

1. 获取 kubectl config 文件

此文件包含连接k8s集群的密钥信息，可以通过 [DevOps实验室]所提供的 [Kubernetes集群实验环境] 的配置页面中获取集群master节点的ssh访问hostname和用户名密码，通过ssh登录此节点后。

注意：如果【DevOps实验室】的【Kubernetes集群实验环境】不可用，讲师会直接提供kube.config文件给到小组。

进入本地用户根目录下的 .kube 文件夹中，我们可以看到有一个名为 config 的文件，此文件即为本机 kubectl 默认链接的集群配置文件

![image.png](images/k8s-22.png)

可以将此文件内容复制出来保存到本地备用。

2. 如果需要使用以上K8s Config登陆集群，可以在安装kubectl的环境中当前用户目录中创建 .kube 文件夹，并在此文件夹下创建 Config 文件，并将以上复制的内容保存到这个文件中

![image.png](images/k8s-21.png)

使用替换文件或修改文件内容的方式修改.kube下的config。

对于使用BOAT-HOUSE jenkins流水线的用户，可以在vm-slave节点上安装kubectl并配置 k8s config 文件以便允许jenkins流水线连接到k8b集群。

3. 保存完毕后运行命令，查看连接情况：

```shell
kubectl get pods -n kube-system
```

![image.png](images/k8s-01.png)

4. 创建 test & prod 命名空间

- 用于Jenkins流水线部署的命令空间：

```shell
kubectl create namespace boathouse-test
kubectl create namespace boathouse-prod
```

![image.png](images/k8s-02.png)
    
   
5. 为命名空间创建 docker-registry-secrets

> 镜像仓库的用户名和密钥可以通过 DevOps实验室 中的环境信息页面获取。

- 用于Jenkins流水线部署

```shell
kubectl create secret docker-registry regcred --docker-server=[docker registry url] --docker-username=[username] --docker-password=[password] --docker-email=info@idcf.io -n boathouse-test
kubectl create secret docker-registry regcred --docker-server=[docker registry url] --docker-username=[username] --docker-password=[password] --docker-email=info@idcf.io -n boathouse-prod
    ```
    
6. Jenkins 添加 Kubeconfig 凭据,ID需为'creds-test-k8s'，找到kube config文件，将里面的所有内容复制到content中
    
![image.png](images/k8s-04.png)

注意：ID 字段同我们的 K8s 部署 yaml 对应，以此默认需要写为 creds-test-k8s

7. 在Jenkins的`configure=>全局属性=>环境变量(勾选)`中 添加 k8s命名空间配置项：
   - DEPLOY_K8S_NAMESPACE_TEST : `boathouse-test`
   - DEPLOY_K8S_NAMESPACE_PROD : `boathouse-prod`

8. 至此，Jenkins 和 K8s 的集群配置就完毕了。

### 触发流水线完成测试环境和生产环境部署

**重要提示：** 当前的k8s环境部署脚本存在一个缺陷，在部署完成后端系统后不会自动创建所需要的数据库实例，这会造成后台api工作不正常。请参考一下 issue 中的说明暂时性修复此问题 https://github.com/idcf-boat-house/boat-house-backend/issues/1

#### 部署测试环境

代码仓库的yaml文件提交完毕，接下来我们开始进行Jenkins流水线的部署。
1. 打开Jenkins流水线，点击分支重新启动流水线
![image.png](images/k8s-12.png)
1. Dev环境部署完毕后，点击同意部署到测试环境
![image.png](images/k8s-05.png)
1. 等待测试环境部署完毕，可以看到该步骤执行成功
![image.png](images/k8s-06.png)
1. 回到命令行，查看测试环境命名空间下的 pods
    ```
    kubectl get pods -n boathouse-test
    ```
    可以看到测试环境已经部署成功
    ![image.png](images/k8s-07.png)
1. 运行以下命令，查看测试环境的 services 列表
    ```
    kubectl get services -n boathouse-test
    ```
    ![image.png](images/k8s-13.png)
    上图中，我们可以看到 client, management, product-service-api 服务均已经启动，外部 IP 地址和端口号也已经可以看到
1. 访问各服务的 IP地址和端口号对应的网站，可以看到环境已经成功在运行中
Client: http://[client-serivce-ip]:[port]
![image.png](images/k8s-14.png)
Management: http://[management-serivce-ip]:[port]
![image.png](images/k8s-15.png)
Product Service Swagger API: http://[product-serivce-api-ip]:[port]/api/v1.0/swagger-ui.html
![image.png](images/k8s-16.png)


#### 部署生产环境

1. 打开Jenkins流水线，点击同意部署到生产环境
![image.png](images/k8s-08.png)
1. 等待生产环境部署完毕，可以看到该步骤执行成功
![image.png](images/k8s-09.png)
1. 回到命令行，查看生产环境命名空间下的 pods
    ```
    kubectl get pods -n boathouse-prod
    ```
    可以看到生产环境已经部署成功
    ![image.png](images/k8s-10.png)
1. 查看生产环境 Services
    ```
    kubectl get services -n boathouse-prod
    ```
    ![image.png](images/k8s-17.png)
1. 访问生产环境网站
![image.png](images/k8s-18.png)
![image.png](images/k8s-19.png)
![image.png](images/k8s-20.png)
