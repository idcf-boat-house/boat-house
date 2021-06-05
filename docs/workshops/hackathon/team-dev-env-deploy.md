### Boat House开发环境部署


在前面的文档中，我们已经部署好Jenkins的流水线，接下来将部署Boat House的Dev环境。
我们将会在云资源的另外一台虚拟机 Docker VM 上部署团队自己的Dev环境：


#### 安装Docker

请使用ssh命令登录vm-dev，并参考如下命令安装Docker以及docker-compose

```
## 更新包管理数据库
sudo apt-get update
## 安装docker
sudo apt install docker.io
sudo usermod -a -G docker ghuser

## 安装docker-compose
### docker-compose 官方安装地址（如果此地址安装不成功，请使用以下国内镜像地址）
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
## docker-compose 国内镜像
sudo curl -L https://get.daocloud.io/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

## 启动 docker 服务
sudo systemctl daemon-reload
sudo systemctl restart docker 

## 设置 docker 用户权限
sudo groupadd docker 
sudo gpasswd -a $USER docker
newgrp docker
```



运行完以上命令重新登陆虚拟机,并执行以下命令，测试Docker是否安装成功
```
docker --version
docker-compose --version
```



#### Jenkins添加Docker VM的连接密钥
1. 打开Jenkins流水线，进入凭据配置界面，点击添加凭证
![image.png](images/teamguide-cd-01.png)
1. 添加vm-dev的连接密钥
用户名密码为登陆vm-dev的用户名密码，ID需为‘creds-dev-server’。
![image.png](images/teamguide-cd-02.png)

#### Jenkins添加Docker Registry的连接密钥


管理员提供给本组的镜像仓库的用户名以及密码，ID需'creds-github-registry’。
![image.png](images/teamguide-cd-06-v2.png)

#### Jenkins添加SonarQube链接Token（类型：Secret Text）

Secret可以暂时不填写，后面配置Sonar时在配置,ID需 ‘token_sonarqube’

注意：此配置虽然在没有用sonar的情况下没有用，但是jenkinsfile中使用了这个token，如果不配置流水线将无法运行。你可以在后续启用son的时候再更新此token为正确的取值，当前可以输入任何内容

![image.png](images/sonar01.png)


#### 启动master分支构建
1. 点击master分支后面的构建button，启动构建
![image.png](images/teamguide-cd-10.png)
1. 构建过程中查看输出情况
![image.png](images/teamguide-cd-11.png)

#### 查看部署结果
Dev环境部署完毕，打开以下链接，查看部署结果：
1. Client Web 
http://{vm-dev ip address}:5000
![image.png](images/teamguide-cd-12.png)
1. Management Web
http://{vm-dev ip address}:5001
![image.png](images/teamguide-cd-13.png)
1. Product Service AP Swagger UI
http://{vm-dev ip address}:7001/api/v1.0/swagger-ui.html
![image.png](images/teamguide-cd-14.png)

**注意：暂时没有提供k8s集群环境，所以大家暂时不要部署测试以及生产环境**
