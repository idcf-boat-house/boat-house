# IDCF 社区共创文档库

## 1.初始化环境

为了能让团队更好的进行开发调试包括对整个DevOps工具链进行搭建以及测试，维护团队为每个团队提供了2台虚拟机用于工具链以及测试环境的搭建

环境配置如下：

* VM-Tools（用于搭建工具链） （CPU: 2 Core MEM: 8G）
* VM-Dev（用于搭建测试环境） （CPU: 2 Core MEM: 4G）

###### 1.1 获取团队云资源

维护团队已经为每个团队分配了两台虚拟机，如果团队还没有拿到的话可以在微信群里直接 @维护团队成员，获取虚拟机相关信息。

**注意：每一个团队只有一套环境！，大家可以一起搭建，也可以指定一位成员搭建**

###### 1.2 团队环境配置

[团队环境配置](team-env-config.md)

[示例代码导入](verson-control-config.md)


###### 1.3 团队流水线配置

- [团队流水线配置(Jenkins)](team-pipeline-config.md)

###### 1.4 团队开发环境部署

[团队开发环境部署](team-dev-env-deploy.md)

###### 1.5 团队 K8s 环境（Test & Prod）部署

[boathouse 部署至k8s-K8s初始配置和Jenkins流水线配置](team-k8s-env-config.md)


###### 1.6 团队 K8s 环境（Test & Prod）部署

[快速开发指南](dev-guide.md)
