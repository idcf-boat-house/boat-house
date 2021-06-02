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
➜  boat-house git:(master) ✗ kubectl get po -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-54d67798b7-krqgh           1/1     Running   0          17m
kube-system   etcd-minikube                      1/1     Running   0          17m
kube-system   kube-apiserver-minikube            1/1     Running   0          17m
kube-system   kube-controller-manager-minikube   1/1     Running   0          17m
kube-system   kube-proxy-h5pk6                   1/1     Running   0          17m
kube-system   kube-scheduler-minikube            1/1     Running   0          17m
kube-system   storage-provisioner                1/1     Running   2          17m
```

## 04. 在 Virutal Box 上安装Linux虚拟机

DevOpsBox是我们用来运行DevOps核心工具链的虚拟机环境，我们在这个虚拟机上适配了DevOps工具链中的核心工具，帮助大家在自己的本地环境进行各种DevOps实践的操作。

### 04.1 创建Virutal Box虚拟机

首先从Boathouse资源网盘下载 ubuntu安装iso 文件

- 链接: https://pan.baidu.com/s/1NAgfpofbhE368ethbuD8OQ  密码: wo8p

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

注意：这个设置非常重要，让DevOpsBox和MiniKube使用同样的主机网络可以确保两台虚拟机处于同一个子网，以便进行通讯，同时，因为主机网络与宿主机是相通的，我们就可以在宿主机（你的开发机）上使用各种工具访问我们的环境。

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

### 04.3 获取虚拟机ip地址并使用ssh登录虚拟机

在VirutalBox控制台中使用我们的默认账号登录

- 用户名：localadmin
- 密码：devops@2021

![](images/04-devopsbox-ssh01.png)


