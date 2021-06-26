# IDCF 社区共创文档库

## 1. 环境概述

为了能让团队更好的进行开发调试包括对整个DevOps工具链进行搭建以及测试，维护团队为每个团队提供了以下配套环境

环境配置如下：

- 2台 Linux 虚拟机
  - VM-Tools（用于搭建工具链） （CPU: 2 Core MEM: 8G）
  - VM-Dev（用于搭建测试环境） （CPU: 2 Core MEM: 4G）
- 1个 Azure Container Registry 镜像仓库
- 1个 k8s 集群

### 获取团队云资源

维护团队已经为每个团队分配了两台虚拟机，如果团队还没有拿到的话可以在微信群里直接 @维护团队成员，获取虚拟机相关信息。

**注意：每一个团队只有一套环境！，大家可以一起搭建，也可以指定一位成员搭建**

## 2. 基础流水线搭建和dev环境部署

### 2.2 团队环境配置

[示例代码导入](verson-control-config.md)

[Jenkins服务器搭建](team-env-config.md)：Jenkins服务器搭建，添加节点并安装插件。

### 2.3 使用Jenkins完成到dev环境的自动化部署

[流水线配置](team-pipeline-config.md)：从代码库中导入Jenkinsfile

### 2.4 团队快速开发指南

[快速开发指南](dev-guide.md)：如何使用本地开发工具调试BoatHouse的前后端代码。

### 2.4 团队开发环境部署

[使用流水线完成Dev环境的自动化部署](team-dev-env-deploy.md)：使用流水线完成Dev环境的自动化部署

## 3. 完整流水线搭建和测试/生产环境部署

### 3.1 加分项 - 团队 K8s 环境（Test & Prod）部署

[使用流水线完成Test/Prod环境的自动化部署](team-k8s-env-config.md)

### 3.2 加分项 - 高级流水线组件

完成本链接中（工具指导文档）中的任意配置，团队可以获得额外加分。

[Boathouse工具链指导文档列表](../../../README.md?id=工具指导文档)