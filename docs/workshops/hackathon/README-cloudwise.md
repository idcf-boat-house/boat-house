# IDCF DevOps 黑马马拉松操作手册 (云智慧版)

## 1. 环境概述

为了能让团队更好的进行开发调试包括对整个DevOps工具链进行搭建以及测试，我们为每个团队提供了以下配套环境

![Boathouse Environment](images/boathouse-env-architecture.png)

基础设施环境说明：

- 2台 Linux 虚拟机（团队自行分配2台VM的用途）
  - VM#1: VM-Tools（用于搭建工具链） （CPU: 2 Core MEM: 8G）
  - VM#2: VM-Dev（用于搭建测试环境） （CPU: 2 Core MEM: 4G）
- 1个 容器镜像仓库 （使用微软Azure云的Azure Container Registry)
- 1个 k8s 集群（使用微软Azure云的Azure Kubernetes Services）
  - k8s 总会通过 命名空间（NS）划分成 Test/Prod 两个环境

应用环境说明：
- 开发调测环境（DEV）：使用docker单机环境，代码提交后，通过流水线自动完成部署
- 测试环境（TEST）：使用k8s集群中的Namespace环境，DEV环境部署通过后，由测试团队批准对TEST环境的部署
- 生产环境（PROD）：使用k8s集群中的Namespace环境，TEST环境部署通过后，由测试团队完成测试并提交测试报告，产品团队确认后，批准对PROD环境的部署


### 获取团队云资源

云智慧所使用的流水线基础环境已经搭建完毕，各团队可以直接申请加入对应的Gitee组织即可开始提交代码，并通过流水线完成自动化部署。

**注意：每一个团队只有一套环境! 大家注意做好分工。**

## 2. 基础流水线

各团队需要提交开发团队成员的Gitee账号给到讲师，讲师为每个团队成员完成组织授权后，小组成员即可开始使用Gitee组织下的代码库。

![Gitee Org](images/gitee-org.png)

请按照以下快速开发指南完成前后端代码的本地调试，并在前端Client应用的菜单中增加一个选项，通过流水线自动部署到DEV环境。

- [快速开发指南](dev-guide.md)：搭建本地开发环境，完成Boathouse前后端代码的联调。

## 3. 增强型流水线

### 3.1 加分项 - 团队 K8s 环境（Test & Prod）部署

- [使用流水线完成Test/Prod环境的自动化部署](team-k8s-env-config.md)：按照此文档完成K8s环境中的 TEST 和 PROD 两个环境的部署。

### 3.2 加分项 - 高级流水线组件

- 完成本链接中（工具指导文档）中的任意配置，团队可以获得额外加分 [Boathouse工具链指导文档列表](../../../README.md?id=工具指导文档)

## 小结

本文档描述了IDCF DevOps 黑客马拉松的流水线搭建过程。
