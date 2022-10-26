# Jenkins服务器搭建

Jenkins作为Boathouse流水线的底层工具，需要通过容器来托管环境。本文档描述了如何通过SmartIDE快速搭建一套Jenkins的运行环境。


## 1. 创建Boathouse流水线工作区

登录到 SmartIDE Sever - http://dev.smartide.cn

点击工作区 ｜ 工作区管理 ｜ 新增工作区，并输入Fork的boathouse-shop-pipeline代码库地址，如下图所示：

![](images/20221026111218.png)  

点击 确定 后，SmartIDE 会开始自动创建流水线环境，等待工作区详情页显示出以下状态，即可点击 VSCode 图标进入工作区操作。

![](images/20221026111327.png)  




## 2. 创建Jenkins服务器

进入 VSCode WebIDE 后，系统会自动安装docker插件，然后你可以展开左侧的 文件列表，找到 /jenkins/docker-compose.yml 文件，右键点击选择 Compose Up 选项，即可启动 Jenkins 服务器。

![](images/20221026111426.png)  

Compose Up 启动完毕

![](images/20221026111441.png)  

现在可以通过点击 工作区详情页 上的 Jenkins 图标打开 Jenkins服务器。

![](images/20221026111518.png)  

### 3. 为Jenkins服务器导入所需插件

Jenkins依赖各种插件完成操作，因为网络原因直接下载插件并不稳定，因此我们在 Boathouse-Pipeline 代码仓中直接提供了下载好的插件，请使用以下脚本导入插件。

```
## 复制 插件到 Jenkins 服务器运行目录
sudo cp -r /home/project/jenkins/plugins /home/smartide/jenkins/jenkins_home/
```

完成以上操作后，通过 Docker 控制台重新启动 Jenkins 服务器。

![](images/20221026111653.png)  

Jenkins 重新启动中

![](images/20221026111706.png)  


### 4. Jenkins初始化配置

点击 Manage Jenkins | configureSecurity，如下图所示：

![](images/20221026112926.png)  

选择 Agent，点击Disable，以及CSPF Protection ｜ Enable proxy compatibility，如下图所示：

![](images/20221026113105.png)  

打开Jenkins认证，Security Realm 选择 Jenkins's own user database, Authorization 选择Anyone can do anything, 最后点击Apply && Save

![](images/20221026113345.png)  



### 5. 为Jenkins服务器添加代理节点

我们的工作区中存在另外一个叫做 boathouse-pipeline-agent 的环境，我们将使用这个环境作为 Jenkins 服务器的工作节点，为了操作这个环境，我们可以使用以下ssh指令远程进入:

```
ssh smartide@boathouse-pipeline-agent -p 6822
```

注意：登录之后的terminal状态切换为：smartide@boathouse-pipeline-agent 

![](images/20221026111844.png)  

进入到 boathouse-pipeline-agent 后，我们创建一个 Jenkins的工作目录，/home/smartide/jenkins_workspace

![](images/20221026111904.png)  




### Jenkins 配置
Jenkins流水线中的各个任务的运行需要跑在一台代理机上，因此我们需要给Jenkins添加构建节点。
在本示例中将使用本机同时作为 Jenkins VM 作为代理机。


### 代理机安装JDK
```
sudo apt-get install openjdk-8-jdk
java -version
```

### 安装Maven

```
sudo apt install maven
```


### 代理机创建Jenkins工作目录, 并创建文件确保目录在非sudo下可写
  ```
  mkdir jenkins_workspace
  cd jenkins_workspace
  touch test
  ls
  ```


### Jenkins添加构建节点
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
    | Remote root directory	 | /home/smartide/jenkins_workspace |
    | Labels | vm-slave (此处很关键，后面JenkinFile流水线文件中会根据此label选取代理机) |
    | Launch method | Launch agents via SSH |
    | Host | boathouse-pipeline-agent |
    | Host Key Verification Strategy | Non verifying Verification Strategy |

1. 创建链接到salve的认证


![image.png](.attachments/image-85931b08-91f1-42f1-97f6-1ba1d681eeeb.png)

1. 在认证编辑界面输入参数：
    | 参数名 | 参数值 |
    |--|--|
    | Username | smartide |
    | Password | root123 |
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

