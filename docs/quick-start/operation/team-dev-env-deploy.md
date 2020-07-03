### Boat House开发环境部署


在前面的文档中，我们已经部署好Jenkins的流水线，接下来将部署Boat House的Dev环境。
我们将会在云资源的另外一台虚拟机 Docker VM 上部署团队自己的Dev环境：


#### 安装Docker

请使用ssh命令登录vm02，并参考如下命令安装Docker以及docker-compose

```
sudo apt-get update
sudo apt install docker.io
sudo usermod -a -G docker localadmin
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl daemon-reload
sudo systemctl restart docker 

sudo groupadd docker #添加docker用户组
sudo gpasswd -a $USER docker #将登陆用户加入到docker用户组中
newgrp docker #更新用户组
```

运行完以上命令重新登陆虚拟机,并执行以下命令，测试Docker是否安装成功
```
docker --version #docker
docker-compose --version #docker-compose
```

#### Jenkins添加Docker VM的连接密钥
1. 打开Jenkins流水线，进入凭据配置界面，点击添加凭证
![image.png](images/teamguide-cd-01.png)
1. 添加Docker VM的连接密钥
用户名密码为登陆Docker VM的用户名密码，ID需为‘creds-dev-server’。
![image.png](images/teamguide-cd-02.png)

#### Jenkins添加Github Docker Registry的连接密钥
1. 打开Github，找到Fork到团队集成账户的BoatHouse Repo，并进入Packages Tab
![image.png](images/teamguide-cd-03.png)
1. 进入Packages，选择docker：
![image.png](images/teamguide-cd-04.png)
1. 获取到Docker Registry的URL, 用户名和密码（密码为PAT）
![image.png](images/teamguide-cd-05.png)
1. 回到Jenkins凭据页面，添加Github Docker Registry的连接密钥
用户名为Github ID， 密码为Github 用户PAT，ID需'creds-github-registry’。
![image.png](images/teamguide-cd-06.png)

#### 开发环境部署脚本替换镜像仓库地址
1. Fork Boat-House 项目到团队账号的Repo，并使用Git 迁出至本地，打开根目录下docker-compose-template.yml 开发环境部署脚本文件：
![image.png](images/teamguide-cd-15.png)
![image.png](images/teamguide-cd-16.png)
1. 如上图所示，部署脚本文件中有五个service结点，名称分别为
 client,
 management, 
 statics-service-api, 
 statics-service-worker, 
 product-service-api
1. 此五个结点中所依赖的镜像即为我们CI自己创建的镜像，因此需要替换这五个结点的镜像地址为团队账号GitHub Package的地址：
![image.png](images/teamguide-cd-17.png)
1. 另外的Service结点所需要的基础镜像不用更换地址。
1. 修改代码完毕后，提交到团队账号的GitHub Repo。
![image.png](images/teamguide-cd-18.png)

#### 启动master分支构建
1. 点击master分支后面的构建button，启动构建
![image.png](images/teamguide-cd-10.png)
1. 构建过程中查看输出情况
![image.png](images/teamguide-cd-11.png)

#### 查看部署结果
Dev环境部署完毕，打开以下链接，查看部署结果：
1. Client Web 
http://{Docker VM Host}:5000
![image.png](images/teamguide-cd-12.png)
1. Management Web
http://{Docker VM Host}:5001
![image.png](images/teamguide-cd-13.png)
1. Product Service AP Swagger UI
http://{Docker VM Host}:7001/api/v1.0/swagger-ui.html
![image.png](images/teamguide-cd-14.png)

**注意：暂时没有提供k8s集群环境，所以大家暂时不要部署测试以及生产环境**
