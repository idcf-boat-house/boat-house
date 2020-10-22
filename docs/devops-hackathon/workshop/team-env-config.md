### 登录虚拟机

使用ssh登录vm-tools
```
ssh localadmin@<ip>
```

### 1. Docker 安装

由于整个环境我们都使用容器的进行部署，所以需要在环境中先安装Docker以及docker-compose，执行以下shell命令安装。
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
# docker
docker --version

# docker-compose
docker-compose --version
```

### 2. 搭建Jenkins
使用以下命令完成Jenkins的安装

```
sudo mkdir ~/jenkins_home 
sudo chown -R 1000:1000 ~/jenkins_home
sudo docker run -d -p 8080:8080 -p 50000:50000 -v ~/jenkins_home:/var/jenkins_home -u 0 jenkins/jenkins:lts
docker ps
```
![image.png](images/teamguide-env-05.png)

##### 获取管理员账号密码
``` 
sudo cat jenkins_home/secrets/initialAdminPassword
```
![image.png](images/teamguide-env-06.png)
复制上面的输出结果

##### 启动Jenkins网站
在浏览器中打开jenkins站点，粘贴上面的管理员密码，并点击 **Continue** 按钮
![image.png](.attachments/image-e3ec56b5-7ecb-408e-a2f2-4a9f806f6044.png)

##### 选择安装建议插件
![image.png](.attachments/image-a41c5f66-6d30-476b-9bd9-b0eab010fd2e.png)

##### 初始化管理员账号密码，都填写为admin即可，然后点击 **Save and Continue**
![image.png](.attachments/image-a384fbd7-0205-4405-b31d-cbd84c69fb34.png)

##### 保持默认的URL设置
![image.png](.attachments/image-d645d145-3189-4960-9afa-93f4b77f3442.png)

##### 完成服务器搭建，启动Jenkins
![image.png](.attachments/image-c0287ce8-f8b7-4ab4-ab48-3d3a22980cd9.png)

****

#### Jenkins 配置
Jenkins流水线中的各个任务的运行需要跑在一台代理机上，因此我们需要给Jenkins添加构建节点。
在本示例中将使用本机同时作为 Jenkins VM 作为代理机。


##### 代理机安装JDK
```
sudo apt-get install openjdk-8-jdk
java -version
```

![image.png](images/teamguide-env-07.png)

##### 安装Maven

```
sudo apt install maven
```

##### 代理机添加localadmin（当前登陆账号）至Sudoers
1. 添加localadmin至sudo组：
    ```
    sudo usermod -aG sudo localadmin
    ```
1. 添加localadmin至sudoers文件：
    ```    
    sudo vim /etc/sudoers
    # /etc/sudoers文件最末尾添加下面代码：localadmin ALL=(ALL) NOPASSWD:ALL
    ```

##### 代理机创建Jenkins工作目录, 并创建文件确保目录在非sudo下可写
  ```
  mkdir jenkins_workspace
  cd jenkins_workspace
  touch test
  ls
  ```
![image.png](images/teamguide-env-08.png)


##### Jenkins添加构建节点
1. 在jenkins管理界面进行节点管理，**Manage Jenkins**
![image.png](.attachments/image-11b5a0bd-b400-467b-b98c-4c344a74db9f.png)

1. 点击 **Manage Nodes** 
![image.png](.attachments/image-0dc74956-80c3-4a37-bfe0-850fd2213e6e.png)

1. 点击  ** New Node**
![image.png](.attachments/image-db115b9c-00be-4206-8753-5610dd18c426.png)

1. 按照下图输入代理名称并勾选**Permanent Agent**，然后点击 **OK**
![image.png](.attachments/image-ace3ea5f-52f2-4013-b065-84419feb7e46.png)

1. 在创建节点界面输入参数:
    | 参数名 | 参数值 |
    |--|--|
    | # of executors | 1 |
    | Remote root directory	 | /home/localadmin/jenkins_workspace |
    | Labels | vm-slave (此处很关键，后面JenkinFile流水线文件中会根据此label选取代理机) |
    | Launch method | Launch agents via SSH |
    | Host | 虚拟机公网IP地址 |
    | Host Key Verification Strategy | Non verifying Verification Strategy |

1. 创建链接到salve容器认证
![image.png](.attachments/image-85931b08-91f1-42f1-97f6-1ba1d681eeeb.png)

1. 在认证编辑界面输入参数：
    | 参数名 | 参数值 |
    |--|--|
    | Username | {代理机Username} |
    | Password | {代理机Password} |
    | ID | vm-slave |
    | Description | vm-slave |

1. 然后点击 **Add**
![image.png](.attachments/image-d235d0cf-666a-456c-bad0-ee0a1ac81b4b.png)

1. 返回节点编辑界面后，选择刚才新建的认证
![image.png](.attachments/image-030ed7e1-3465-45a5-804a-d77d7f5d16a2.png)

1. 完成节点编辑，点击**Sava**
![image.png](.attachments/image-eb750ef8-02a1-4b01-99ae-02d2ec3a97a4.png)

1. 回到列表页面后启动节点
![image.png](.attachments/image-5be50e60-6c2e-45fa-8e26-840d8b4054b0.png)

1. 按照下图手动点击启动节点
![image.png](.attachments/image-c3b64c49-4aad-48c2-8f0d-edb4bf079d0c.png)

1. slave正常启动
![image.png](.attachments/image-84216118-0f35-404d-8783-df5e5f988dd3.png)

1. 回到节点列表
![image.png](.attachments/image-9ad7c3e6-3fd0-4c47-9e39-c2e3951010d5.png)

1. 节点显示正常
![image.png](.attachments/image-c4719f72-3235-4e3d-8a4b-cfb2f3576e2e.png)

##### Jenkins安装插件

1. 打开Jenkins控制面板首页，在左侧菜单中选择 **管理Jenkins** ，进入管理页面后，点击 **管理插件**，安装插件： Cobertura、Kubernetes Continuous Deploy、SSH Pipeline、Blue Ocean
![image.png](.attachments/image-8a08c02b-a942-47b1-9bfd-54cdb2429495.png)
1. 进入插件页面， 选择项目的 **可用** tab，并在上面搜索框中输入 **cobertura** 找到cobertura插件，选择安装
![image.png](images/teamguide-ci-03.png)
1. 进入插件页面， 选择项目的 **可用** tab，并在上面搜索框中输入 **Kubernetes Continuous Deploy** 找到k8s CD 插件，选择安装
![image.png](images/teamguide-ci-04.png)
1. 进入插件页面， 选择项目的 **可用** tab，并在上面搜索框中输入 **SSH Pipeline** 找到SSH Pipeline Steps插件，选择安装
![image.png](images/teamguide-ci-05.png)
1. 进入插件页面， 选择项目的 **可用** tab，并在上面搜索框中输入 **Blue Ocean** 找到blueocean插件，选择安装
![image.png](.attachments/image-339b4bef-042b-41fd-b375-fced13429eab.png)

至此，团队环境中的Jenkins设置完毕。
****
