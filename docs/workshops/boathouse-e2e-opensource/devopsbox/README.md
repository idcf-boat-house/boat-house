# DevOpsBox 安装说明

## 01. 安装并配置 Virutal Box

Virtual Box 是免费的虚拟机工具，可以在Windows/MacOS/Linux三种主流操作系统上运行，对于搭建开发测试和实验环境非常方便。

以下安装过程同时适用于三种环境

从 [下载地址](https://www.virtualbox.org/wiki/Downloads) 下载后直接安装，使用所有默认设置即可。

安装完成后，打开【主机网络管理器】检查网络设置

![](images/01-vb-network.png)

默认情况下，VirutalBox应该已经创建了 192.168.99.1/24 网段的主机网络

![](images/01-vb-network-02.png)

## 02. 安装并配置 Docker for Desktop

Docker for Desktop 是 Docker 提供的官方工具，支持在Windows和MacOS上使用 docker 和 docker compose 工具，同时会利用操作系统的虚拟化能力提供流畅的容器运行环境。

从 [下载地址](https://www.docker.com/products/docker-desktop) 下载后直接安装。

注意：如果你使用的是Windows环境，请先按照[官方文档安装WSL2](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10)，然后使用WSL2的方式在Windows上安装Docker Desktop，你会在安装向导中看到如下选项：确保你勾选了 Install requried Windows components for WSL 2

![](images/02-docker02.png)

安装完成后打开Docker Desktop设置应该看到如下设置，确保 Use WSL 2 based engine 已经正确勾选

![](images/02-docker03.png)

说明：WSL2 是 Windows Subsystem for Linux 第二代系统的简称，可以允许我们在Windows上运行Linux操作系统内核，因为大多数Docker容器是为Linux操作系统设计的，所以我们需要一个可以运行Linux操作系统的环境。老版本的Docker Desktop使用Windows Hyper-V虚拟机运行Linux VM的方式来支持这个场景，但是会造成不必要的系统复杂度，而且也会造成我们无法使用Virutal Box (因为Hyper-V和VirutalBox并不兼容)。为了保持我们的DevOpsBox环境在Windows和MacOS上的一致性（因为MacOS上无法运行Hyper-V）,因此我们在Windows上推荐使用WSL2的方式运行Docker Desktop以便我们可以同时使用Virutal Box。

安装完成后可以在控制栏上看到 Docker 图标

![](images/02-docker01.png)

### 验证Docker环境工作正常

打开任何命令行工具，运行以下命令，如果能够看到类似的输出，则表示docker工作正常

```shell
➜  docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
b8dfde127a29: Pull complete 
Digest: sha256:5122f6204b6a3596e048758cabba3c46b1c937a46b5be6225b835d091b90e46c
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

运行以下命令确认你的工具版本不低于以下输出

```shell
➜  docker --version
Docker version 20.10.6, build 370c289
➜  docker-compose --version
docker-compose version 1.29.1, build c34c88b2
```

## 03. 安装并配置阿里云版MiniKube

Minikube是谷歌为Kubernetes开发者提供的本地单机版k8s环境，可以用于开发测试和实验操作，阿里云为国内的开发者提供了适配国内网络环境的版本，相关链接如下：

### 安装说明

- MiniKube 官方资源（不要使用这里的方式安装，但是可以参考官方文档）
  - 安装说明：https://kubernetes.io/docs/tasks/tools/
  - 官方文档：https://minikube.sigs.k8s.io/
- MiniKube 阿里云资源
  - Github仓库：https://github.com/AliyunContainerService/minikube
  - 阿里云开发者社区文档（请按照此文档进行安装）：https://developer.aliyun.com/article/221687

### 创建minikube示例脚本

按照以上安装说明完成安装后就可以使用以下脚本创建你的minikube实例了，第一次运行这个脚本会比较慢，因为minikube需要从阿里云上下载minikube所需要的虚拟机iso文件以及k8s本身的组件资源。如果运行过程中出错，请参考以下【错误处理】部分尝试修复。


```shell
# MacOS环境命令和输出如下
minikube start --driver=virtualbox
```

![](images/03-minikube-macos01.png)

```shell
# Windows环境命令和输出如下
# 注意此处添加了 --no-vtx-check 选项，如果不加入这个参数有时候Windows上会报无法识别虚拟化系统错误
minikube start --driver=virtualbox --no-vtx-check
```

![](images/03-minikube-win01.png)

### 验证minikube工作正常

执行以下命令，如果看到类似的输出，则表示minikube工作正常。

```shell
## 以下命令列出minikube上运行的所有系统pod的运行状态
### 以下命令实际上使用了k8s的官方客户端工具kubectl，如果你本地没有安装这个工具，minikube会首先为你下载安装这个工具
### 以下命令执行成功后你可以直接使用 kubectl get po -A 进行操作
kubectl get po -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-54d67798b7-krqgh           1/1     Running   0          17m
kube-system   etcd-minikube                      1/1     Running   0          17m
kube-system   kube-apiserver-minikube            1/1     Running   0          17m
kube-system   kube-controller-manager-minikube   1/1     Running   0          17m
kube-system   kube-proxy-h5pk6                   1/1     Running   0          17m
kube-system   kube-scheduler-minikube            1/1     Running   0          17m
kube-system   storage-provisioner                1/1     Running   2          17m

### 直接使用kubectl操作minikube集群
kubectl get pods -n kube-system
```

## 04. 在 Virutal Box 上安装Linux虚拟机

DevOpsBox是我们用来运行DevOps核心工具链的虚拟机环境，我们在这个虚拟机上适配了DevOps工具链中的核心工具，帮助大家在自己的本地环境进行各种DevOps实践的操作。

### 04.1 创建Virutal Box虚拟机

首先从Boathouse资源网盘下载 ubuntu安装iso 文件

![](images/04-devopsbox01.png)

在VirtualBox中创建虚拟机，命名为 DevOpsBox， 选择 Linux 和 Ubuntu (64-bit)

![](images/04-devopsbox02.png)

内存至少给予 4096MB，如果你的本地环境有更多资源，可以多分配一些

![](images/04-devopsbox03.png)

选择 现在创建虚拟磁盘

![](images/04-devopsbox04.png)

磁盘选择默认的 VDI磁盘，并使用 动态分配 方式

![](images/04-devopsbox05.png)

![](images/04-devopsbox06.png)

调整磁盘大小为 20G（你可以根据需要调整，一般实验用途20G够用了）

![](images/04-devopsbox07.png)

创建好的虚拟状态如下，点击 设置按钮 进入设置

在 存储 菜单中添加我们下载的iso文件作为安装介质

![](images/04-devopsbox08.png)

在 网络 菜单中添加 网卡2 设置，指定到前面 minikube 所使用的 主机网络上，此处是 vboxnet0 (你的环境可能有所不同，请打开minikube虚拟机设置，找到minikube的网卡2设置，使用同样的配置即可)

![](images/04-devopsbox09.png)

注意：

1. 这个设置非常重要，让DevOpsBox和MiniKube使用同样的主机网络可以确保两台虚拟机处于同一个子网，以便进行通讯，同时，因为主机网络与宿主机是相通的，我们就可以在宿主机（你的开发机）上使用各种工具访问我们的环境。
2. 如果你使用的是windows上的virutal box环境，系统本身只有一个网段为192.168.56.0/24的主机网络网卡，通过安装minikube会自动创建另外一块192.168.99.0/24的网卡，我们后续需要使用的是这块主机网络网卡。

### 04.2 启动虚拟机完成操作系统安装

使用默认语言设置

![](images/04-devopsbox-ub01.png)

选择 Install Ubuntu Server

![](images/04-devopsbox-ub02.png)

选择 Englsh - English 作为安装语言

![](images/04-devopsbox-ub03.png)

选择 Hong Kong 作为安装位置

![](images/04-devopsbox-ub04.png)

选择 No 不要检测键盘设置

![](images/04-devopsbox-ub05.png)

使用 English (US) 作为键盘设置

![](images/04-devopsbox-ub06.png)

选择 第一个网卡 作为默认网卡，这里是 enp0s3

注意：这里选择的网卡是在设置中指定的 网卡1，网卡1 默认使用NAT网络可以访问外网，这样可以保证我们的虚拟机访问从互联网

![](images/04-devopsbox-ub07.png)

将虚拟机命名为 DevOpsBox

![](images/04-devopsbox-ub08.png)

使用 localadmin 作为第一个用户的用户名（你也可以使用其他用户名，但是Boathouse实验手册中会统一使用localadmin作为默认的管理员用户）

![](images/04-devopsbox-ub09.png)

设置 localadmin 用户的密码为 devops@2021 （你可以设置为其他密码，但是Boathouse实验手册中会统一使用这个默认秘密啊）

![](images/04-devopsbox-ub10.png)

选择 No 不要加密home目录

![](images/04-devopsbox-ub11.png)

虚拟机会开始检测你的时区，使用默认设置即可

![](images/04-devopsbox-ub12.png)

选择 Guided - use entire disk 作为分区设置

![](images/04-devopsbox-ub13.png)

选择默认磁盘后，在确认页中选择 Yes 

![](images/04-devopsbox-ub14.png)

安装过程启动

![](images/04-devopsbox-ub15.png)

中间如果提示设置 Proxy，则留空直接选择 Continue，此时安装程序需要从网络上下载一些更新安装包

![](images/04-devopsbox-ub16.png)

在系统更新设置中选择 No automatic updates 不要自动更新

![](images/04-devopsbox-ub17.png)

在软件包选择中，选择

- standard system utilities 标准系统工具
- OpenSSH Server SSH服务器

![](images/04-devopsbox-ub18.png)

等待系统完成安装工作

![](images/04-devopsbox-ub19.png)

选择 Yes 安装 GRUB boot loader 作为主引导

![](images/04-devopsbox-ub20.png)

安装完成，点击 continue

![](images/04-devopsbox-ub21.png)

### 04.3 配置虚拟机的主机网络ip地址并使用ssh登录虚拟机

在VirutalBox控制台中使用我们的默认账号登录

- 用户名：localadmin
- 密码：devops@2021

![](images/04-devopsbox-ssh01.png)

现在我们需要激活我们增加的 网卡2，并且让这块网卡使用前面配置的主机网络子网 (192.168.99.1/24网段)，在虚拟机中键入如下命令：

```shell
## 查询操作系统上可用网卡状态
ifconfig -a
```
系统反馈如下，以下列出的 enp0s8 就是我们所添加的 网卡2，我们需要为这块网卡绑定搞一个固定的IP地址，以方便我们后续的操作
![](images/04-devopsbox-ssh02.png)


```shell
## 编辑操作系统网络配置文件
sudo vim /etc/network/interfaces
```

在vim编辑器中按 i 开始编辑，并在文件底部添加如下内容，编辑完成以后按 ESC 键推出编辑模式，按 :wq! 保存文件退出

```shell
auto enp0s8
iface enp0s8 inet static
address 192.168.99.102
netmask 255.255.255.0
```

![](images/04-devopsbox-ssh03.png)

使用以下命令从新启动网络系统

```shell
sudo systemctl restart networking
```

如果以上命令正常退出，没有任何错误则表示网络配置成功。

现在你就可以从你的宿主机上开启一个命令行，测试以下是否可以链接到自己的 DevOpsBox 虚拟机了

```shell
## 测试虚拟机IP地址可以联通
ping 192.168.99.102
## 使用ssh连接虚拟机
ssh localadmin@192.168.99.102
```

![](images/04-devopsbox-ssh04.png)

现在你就可以直接通过宿主机的终端操作我们的 DevOpsBox 环境了，后续的操作都可以通过这种方式完成。

### 04.4 完成虚拟机基础环境安装

使用以下脚本配置虚拟机基础环境，包括
- 使用华为开源镜像站作为apt-get源，以便稳定安装操作系统组件
- 安装 docker 和 docker-compose 
- 安装 jdk 和 maven

```shell
## 使用华为镜像站 https://mirrors.huaweicloud.com/
### 1. 备份配置文件
sudo cp -a /etc/apt/sources.list /etc/apt/sources.list.bak
### 2. 修改sources.list文件，将http://archive.ubuntu.com和http://security.ubuntu.com替换成http://repo.huaweicloud.com，可以参考如下命令：
sudo sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
sudo sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list

## 安装 docker 和 docker-compose

## 更新包管理数据库
sudo apt-get update
## 安装docker
sudo apt install docker.io
sudo usermod -a -G docker {你的虚拟机用户名}

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

## 验证 docker 和 docker-compose 工作正常
### 确保你收到的输出版本不低于以下版本号
docker --version
## 应该输出以下版本信息
## Docker version 18.09.7, build 2d0083d
docker-compose --version
## 应该输出以下版本信息
## docker-compose version 1.29.2, build 4667896b

## 安装 jdk 和 maven
sudo apt-get install openjdk-8-jdk  -y
sudo apt install maven -y

## 验证 java 和 maven 工作正常
### 请确保你收到的输出版本不低于以下版本
java -version
## 应该输出以下版本信息
## openjdk version "1.8.0_292"
## OpenJDK Runtime Environment (build 1.8.0_292-8u292-b10-0ubuntu1~16.04.1-b10)
## OpenJDK 64-Bit Server VM (build 25.292-b10, mixed mode)

mvn --version
## 应该输出以下版本信息
## Apache Maven 3.3.9
## Maven home: /usr/share/maven
## Java version: 1.8.0_292, vendor: Private Build
## Java home: /usr/lib/jvm/java-8-openjdk-amd64/jre
## Default locale: en_HK, platform encoding: UTF-8
## OS name: "linux", version: "4.4.0-186-generic", arch: "amd64", family: "unix"
```

至此，我们的 DevOpsBox 基础环境准备完毕

## 05. 配置 Visual Studio Code 通过 SSH Remote 访问 DevOpsBox 环境

Visual Studio Code 提供了一个SSH Remote插件，可以允许我们通过SSH连接到远程环境，方便我们编辑远程环境中的文件以及运行终端。

Visual Studio Code 官方安装地址 https://code.visualstudio.com/

安装好以后，找到 Remote Development 插件并将这个插件安装到你的vscode中，这个插件包括了

- Remote WSL
- Remote Container
- Remote SSH 

以上三个分别可以帮助我们通过vscode远程操作 WSL Container (容器) 和 SSH 远程服务器。

![](images/04-devopsbox-vscode01.png)

Remote Development 插件安装好之后，可以通过左侧的菜单进入，并添加我们的 DevOpsBox 环境

![](images/04-devopsbox-vscode02.png)

添加好之后点击 连接 按钮，选择 Linux 作为目标操作系统类型

![](images/04-devopsbox-vscode03.png)

输入密码后，vscode会自动在目标环境中配置所需要的软件环境，现在我们就可以直接在宿主机上通过vscode操作 DevOpsBox 虚拟机了，如下图

- 左侧的文件浏览器中显示的是远程的 DevOpsBox 虚拟机中的文件系统，你可以复制粘贴，或者拖拽的方式将宿主机的文件直接上传远程服务器
- 底部的 Terminal 则可以直接在 DevOpsBox 上运行命令

我们后续的操作都默认使用vscode remote的方式进行操作。

![](images/04-devopsbox-vscode04.png)

## 05. 在 DevOpsBox 上启动 Boathouse DevOpsBox 工具链环境

首先从Boathouse资源网盘下载 jenkins plugin 的打包文件文件

![](images/04-devopsbox-up01.png)

按照以上步骤通过vscode连接到 DevOpsBox 并通过 Terminal 执行以下动作获取 DevOpsBox 部署配置文件

```shell
git clone https://github.com/idcf-boat-house/boat-house-devopsbox.git
```

![](images/04-devopsbox-up02.png)

在 devopsbox/jenkins 目录中创建一个jenkins_home目录，将解压好的 jenkins plugin 资源文件放入到 devopsbox/jenkins/jenkins_home 目录内。

复制需要一会儿，请注意底部状态栏上的进度提示

![](images/04-devopsbox-up03.png)

复制完成后，运行以下命令即可启动 DevOpsBox 环境，注意docker-compose都需要先进入各个工具的子目录后执行

```shell
## 启动 gitea
cd devopsbox/gitea
docker-compose up -d
cd ../../

## 启动 wekan
cd devopsbox/wekan
docker-compose up -d
cd ../../

## 启动 jenkins
### 首先修正jenkins_home目录权限
cd devopsbox/jenkins
sudo chown -R localadmin:localadmin jenkins_home
docker-compose up -d

## 启动 SonarQube
### 首先配置一些系统参数
#### 查看最大虚拟内存
sysctl -a|grep vm.max_map_count
#### 如果小于 262144，请执行如下命令
sudo sysctl -w vm.max_map_count=262144 
cd devopsbox/sonarqube
docker-compose up -d
```

以上启动完成后，通过以下地址就可以访问环境

- 开源电子看板 wekan http://192.168.99.102:8081
- 开源Git服务器 Gitea http://192.168.99.102:3000
- 开源流水线 Jenkins http://192.168.99.102:8080
- 开源代码检查工具 SonarQube http://192.168.99.102:9000

Wekan 首页 - 可以自行注册用户，第一用户自动成为系统管理员，建议使用统一的localadmin账号

![](images/04-devopsbox-up_wekan.png)

Gitea 首页 - 注意修改 localhost 为 192.168.99.102，将 HTTP 服务端口从 3000 修改为 8082, 并使用 localadmin 作为管理员账号

![](images/04-devopsbox-up_gitea.png)

Jenkins 初始化首页，需要通过以下命令获取初始密钥，并输入到界面中

```shell
cd devopsbox/jenkins/
cat jenkins_home/secrets/initialAdminPassword
```

输入以上命令输出的密钥解锁 Jenkins

![](images/04-devopsbox-up_jenkins01.png)

选择安装推荐的插件（因为我们已经复制了插件到jenkins_home目录，这个步骤会非常快）

![](images/04-devopsbox-up_jenkins02.png)

使用 DevOpsBox 标准管理员账号 lcoaladmin 创建 Jenkins管理员账号

![](images/04-devopsbox-up_jenkins03.png)

完成配置，Jenkins重启后进入登录界面，配置完成。

![](images/04-devopsbox-up_jenkins04.png)

SonarQube启动后，进入后使用 admin/admin 登录并修改默认密码为我们的标准密码

![](images/04-devopsbox-up_sonarqube.png)

至此，我们的DevOpsBox配置完毕，大家现在已经有一个可以运行大多数DevOps实践的工具链环境。

## 06. 停止 DevOpsBox 环境

我们后续的实验中会利用DevOpsBox做一些实验操作，为了避免损毁以上环境或者造成问题，可以通过以下命令停止DevOpsBox中的工具链运行。需要的时候再启动。

```shell
## 停止 gitea
cd devopsbox/gitea
docker-compose down

## 停止 wekan
cd devopsbox/wekan
docker-compose down

## 停止 jenkins
cd devopsbox/jenkins
docker-compose down
```




