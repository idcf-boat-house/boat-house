### Boat House开发环境部署

在前面的文档中，我们已经部署好Jenkins的流水线，接下来将部署Boat House的Dev环境。
我们将会在云资源的另外一台虚拟机 Docker VM 上部署团队自己的Dev环境：

#### 安装Docker

请使用ssh命令登录vm-dev，并参考如下命令安装Docker以及docker-compose

```shell
## 更新包管理数据库
sudo apt-get update
## 安装docker
sudo apt install docker.io
sudo usermod -a -G docker {你当前的登录用户名}

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

```shell
docker --version
docker-compose --version
```

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
