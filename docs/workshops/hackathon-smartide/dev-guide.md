# IDCF Boat House 快速开发指南（SmartIDE）
## IDCF Boat House 项目架构：
![boathouse-arch](images/devguide-boathouse-arch.png)
## 指南概要
如上Boat House项目架构图所示:
* 基于 Spring Boot 框架开发的 **Product Service** 将为Boat House提供 REST API 数据支持；
* 基于Node Js + Vue 框架开发的后端管理平台 **Management Web** 将为Boat House提供后台数据管理功能。

本指南将以 Product Service 和 Boat House 后端管理平台 Management Web 为例，在接下来的三个章节中介绍如何快速上手进行 管理网站 和 后台服务 的开发，以及跨技术栈/IDE情况下如何进行前后端到端的调试。

## Product Service 快速上手指南

### 简介

Boat House Product Service 是 ：
* Boat House 的产品后台数据服务
* 基于Spring Boot 框架开发的 RESTFUL API
* 向前对 Boat House 各网站提供产品数据接口，向后使用MySql数据库进行数据存储

![](images/devguide-product-service-01.png)

### 开发环境

使用SmartIDE容器化开发环境的方式，通过任何浏览器均可进行开发调试，环境中配置好对应的SDK以及docker等工具，不需要在本地安装SDK，开发工具等，所有的这些开发依赖都已经帮您在容器中配置好，你只需要一键启动开发环境，就可以开始你的开发调试。

### 快速开始
1. 访问SmartIDE网站，完成登录
![](images/devguide-smartide-login.png)

2. 配置工作区策略

通过配置工作区策略，设置工作区的git config、ssh key、工作区密码、工作区用户密码。

进入工作区策略配置：

![](images/devguide-smartide-policy-01.png)

开始工作区策略配置：

点击新增创建工作区策略：

![](images/devguide-smartide-policy-02.png)

- git-config：该配置为工作区git提交时的用户信息设置，系统会根据登录用户信息自动设置

![](images/devguide-smartide-policy-03.png)

- ssh-key：该配置为工作区中生成的ssh秘钥信息，其中的公钥信息可配置到任意仓库ssh公钥中，从而实现通过ssh方式拉取代码创建工作区.系统会自动生成秘钥对，用户也可以将本地秘钥进行粘贴修改。

![](images/devguide-smartide-policy-04.png)

- credentials：密码将作为访问工作区的密码或工作区smartide用户密码

![](images/devguide-smartide-policy-05.png)

下面，我们复制刚刚配置好的ssh-key中的rsa-pub信息到源代码仓库服务中，

![](images/devguide-smartide-policy-06.png)

完成以上的基础配置后，下面我们来创建开发环境。

3. 创建开发工作区

下面，我们来创建实验的开发工作区环境，点击左侧[ 工作区管理 ]，然后点击 [ 新增工作区 ]

![](images/devguide-smartide-workspace-01.png)

进入新增工作区页面后，选择资源以及添加代码库地址：

![](images/devguide-smartide-workspace-02.png)

说明：其中资源为已为大家分配好的K8S集群，代码库地址为fork的代码库地址

工作区创建以后，进入到工作区详情页面，待启动完毕后，进入到工作区详情页面中：

![](images/devguide-smartide-workspace-03.png)

4. 打开工作区，并完成开发环境自动初始化准备

点击工作区详情页中的VSCode图标，打开WebIDE：

![](images/devguide-smartide-vscode-01.png)

WebIDE启动后，工具将自动触发以下动作：
- 执行后端代码的mvn package构建
- 安装需要的java扩展包以及docker扩展
- 执行前端代码的npm install以及build
- 启动项目依赖的mysql数据库，并完成初始化。并且，建立网页版的mysql客户端工具phpmyadmin

初始化动作执行完毕后，会识别出JAVA PROJECTS以及MAVEN项目情况：

![](images/devguide-smartide-vscode-02.png)

通过查看Docker扩展，也可以看到已经启动了mysql及phpmyadmin容器：

![](images/devguide-smartide-vscode-03.png)

点击工作区详情页面中的phpmyadmin图标，打开phpmyadmin进行查看：

![](images/devguide-smartide-vscode-04.png)

在打开的phpmyadmin页面中，完成登录：

![](images/devguide-smartide-vscode-05.png)

其中填写信息来源于配置文件.ide/docker-compose-debug.yml，如图所示：

![](images/devguide-smartide-vscode-06.png)

这里可以看到BoatHouse数据库已经建立，并已经完成数据库初始化：

![](images/devguide-smartide-vscode-07.png)

经过查看，开发环境已准备就绪，下面我们来进行开发调试。

5. 后端调试启动

修改后端Boat House Product Service的启动配置，修改profile为dev。

文件路径为：src/product-service/api/src/main/resources/application.properties

![](images/devguide-smartide-debug-01.png)

点击[ JAVA PROJECTS ]中的[ 重新构建工作空间 ]按钮，完成工作空间的构建

![](images/devguide-smartide-debug-02.png)

运行后端Product Service

![](images/devguide-smartide-debug-03.png)

点击工作区详情页面中的后端访问地址：

![](images/devguide-smartide-debug-04.png)

这时，可以查看到后端服务的Swagger UI（需要在打开的链接地址后输入：/api/v1.0/swagger-ui.html）：

![](images/devguide-smartide-debug-05.png)

## Management Web 快速上手指南

### 简介

Boat House Management Web 是：
* Boat House 的后台管理网站
* 基于 Node JS + Express + Vue 框架开发的网站应用
* 向前给 Boat House 管理者提供管理整个餐厅的功能，向后调用 REST API 使用 统计服务/产品服务/账户服务

![](images/devguide-management-web-01.png)

![](images/devguide-debugging-11.png)

### 开发环境

SmartIDE中已内置了nodeJs，npm等工具，前端的代码调试开发也无须进行任何安装配置，在之前打开的浏览器中使用即可。

### 快速开始

工作区环境启动后，前端的npm install 及 build应用打包 操作已自动执行，现在，我们无须任何配置，只需要点击调试，即可打开前端工程的开发调试。

前端代码所在路径为：src/boat-house-frontend

点击左侧Debug工具栏，启动Debug：

![](images/devguide-smartide-debug-06.png)

点击工作区详情页面中的前端访问地址：

![](images/devguide-smartide-debug-07.png)

这时，可以查看到前端页面已经可以访问了：

![](images/devguide-smartide-debug-08.png)

至此，我们将前后端项目都打开了调试模式：

![](images/devguide-smartide-debug-09.png)

## Product Service & Management Web 跨技术栈/IDE连调指南
### 整体架构图：
![](images/devguide-debugging-arch.png)

### 具体步骤
* **Product Service ： IDEA Debugging Mode**

1. 在要调试的方法BoatHouseController.AddFoodCategory()上打断点

文件路径：src/product-service/api/src/main/java/com/idcf/boathouse/product/controller/BoatHouseController.java

![](images/devguide-smartide-debug-10.png)

* **Management Web 后端：VS Code Debugging Mode**
1. 初始化设置
前端在调用到后端时，引用的名称为product-service-api，为避免开发的配置引入到集成环境，首先我们在本地环境需要配置host：
```
## 设置root用户密码，自行设置即可，请记住此密码，建议设置为 root123
sudo passwd root
## 切换到root用户
su
## 在root用户下执行
## 添加product-service-api 映射到 127.0.0.1
echo "127.0.0.1 product-service-api" >> /etc/hosts
## 检查是否添加成功
cat /etc/hosts
## 退出 root 用户模式
exit
```
2. 在 server.js 要调试的后台函数中打断点

文件路径：src/boat-house-frontend/src/management/server.js

![](images/devguide-smartide-debug-11.png)

* **Management Web 前端：用户浏览器（开发者模式）**

1. 打开 Boat House 后台管理网站，并打开[ 菜品分类管理 ]，点击[ 添加菜品分类 ]：

![](images/devguide-smartide-debug-12.png)

2. 添加菜品内容后，点击确定，触发调试

![](images/devguide-smartide-debug-13.png)

3. 首先，调试会先进入我们的前端调试断点，这时我们可以查看堆栈信息以及变量信息：

![](images/devguide-smartide-debug-14.png)

4. 点击继续运行：

![](images/devguide-smartide-debug-15.png)

5. 调试会进入我们的后端调试断点，同时我们依然可以查看堆栈信息以及变量信息

![](images/devguide-smartide-debug-16.png)

6. 再次点击继续运行，数据添加成功：

![](images/devguide-smartide-debug-17.png)

7. 至此，我们完成了前后端联调测试。

**下面，任由您继续发挥吧！**

**SmartIDE Up**



