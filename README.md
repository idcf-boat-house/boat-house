# IDCF 社区共创文档库

- 官网： https://boat-house.cn/    
- 文档库查看地址： http://idcf.org.cn/boat-house

## IDCF 社区共创介绍

* [项目概念](docs/quick-start/operation/proj-description.md)
* [项目组成员](docs/quick-start/operation/team-member.md)
* [迭代计划](docs/quick-start/operation/sprint-plan.md)
* [会议摘要](docs/quick-start/operation/session-note.md)
* [项目直播](docs/quick-start/operation/proj-live-cast.md)
* [技术支持](docs/quick-start/operation/tech-support.md)


### Contributing

* [项目协作流程](docs/quick-start/operation/contributing-flow.md)
* [团队上手指南](docs/quick-start/operation/team-quick-start.md)
* [项目基础环境介绍](docs/quick-start/operation/project-base-inst.md)
* [快速开发指南](docs/quick-start/operation/dev-guide.md)
* [开发规范](docs/quick-start/operation/dev-spec.md)
* [验收标准（AC）](docs/quick-start/operation/ac.md)
* [完成标准（DoD）](docs/quick-start/operation/dod.md)
* [团队代码合并指南](docs/quick-start/operation/code-merge.md)
* [github clone 加速，解决国内慢的问题](docs/quick-start/operation/github-access-proxy-for-cn.md)

## IDCF 相关存储库介绍

### boat-house: 主库(本库)

主要存放基于Boat-house代码库的种实践文档，整个boat-house的共创运作基于此库展开。

**IDCF boat-house 主库目录结构**

- docs
	- quick-start，目前存放一期的团队上手文档和工具实践文档
	- lean
	- agile-team
	- agile-scaled
	- devops-e2e-5p，工具实践文档
	- devops-hackathon，黑客马拉松活动实践文档
		-workshop
	- devops-case-studies，案例研究文档

 
##### 文档库部署

采用 Github Action, 使用 FTP的方式 将此库的MD文件部署至Azure China AppService,访问地址： http://idcf.org.cn/boat-house

[部署脚本](https://github.com/idcf-boat-house/boat-house/actions?query=workflow%3Aboat-house-docs-deploy)

### 基础设施库

[IDCF Boat House 基础设施库](https://github.com/idcf-boat-house/boat-house-infrastructure)

包括vm环境创建脚本，devops相关工具部署脚本

[私有库，存放机密文件，仅限于维护团队，不对外开放](https://github.com/idcf-boat-house/secret-files)

如ssh key、k8s kubeconfig 等文件存放此库。

### boat-house 相关代码库

- boat-house 应用结构及功能

船屋餐饮系统采用微服务架构设计，包含五条业务条线（统计服务、商品服务、账户服务、订单服务、支付服务），每一个业务条线可以独立的开发以及部署。

![](images/boathouse-structure.png)

- 微服务架构和单体架构都采用相同的代码库：
	- [boathouse-frontend: 前端代码库，包括前台和后台的Web前端页面代码](https://github.com/idcf-boat-house/boat-house-frontend)
	- [boathouse-mobile-android: Android客户端代码库](https://github.com/idcf-boat-house/boat-house-mobile-android)
	- [boathouse-backend：后台代码库](https://github.com/idcf-boat-house/boat-house-backend)

- 代码库及技术架构说明： 

| 仓库  | 文件夹  | 服务说明 | 技术架构 |
| ----- | ------------ | ------------ |------------ |
| [boathouse-frontend: 前端代码库](https://github.com/idcf-boat-house/boat-house-frontend) | src/client  | 客户端，船屋餐饮官方网站  | Boatstrap 4 (模版：AppStrap [参考链接](http://demos.themelize.me/appstrap3.3.3/theme/intro.html "参考链接"))  <br> Vue + Nodejs|
| [boathouse-frontend: 前端代码库](https://github.com/idcf-boat-house/boat-house-frontend) | src/management  | 船屋餐饮后台管理系统  | Boatstrap 4 (模版：ModernAdmin [参考链接](https://preview.themeforest.net/item/modern-admin-clean-bootstrap-4-dashboard-html-template/full_screen_preview/21430660?_ga=2.66676205.272140448.1583930719-396544145.1583854564 "参考链接"))  <br> Vue + NodeJs |
| [boathouse-mobile-android: Android客户端代码库](https://github.com/idcf-boat-house/boat-house-mobile-android)|src/boat-house-android-proj|安卓客户端|Android native APP+MVP|
|[boathouse-backend：后台代码库](https://github.com/idcf-boat-house/boat-house-backend) | src/statistics-service  | 业务条线 - 统计服务  | nodejs + dotnet + redis + postgres  |
|[boathouse-backend：后台代码库](https://github.com/idcf-boat-house/boat-house-backend) | src/product-service  | 业务条线 - 产品服务  |spring boot + mysql |
|[boathouse-backend：后台代码库](https://github.com/idcf-boat-house/boat-house-backend) | src/account-service  | 业务条线 - 账户服务  |spring boot + mysql |
|[boathouse-backend：后台代码库](https://github.com/idcf-boat-house/boat-house-backend) | src/order-service  | 业务条线 - 订单服务  |spring boot + mysql |
|[boathouse-backend：后台代码库](https://github.com/idcf-boat-house/boat-house-backend) | src/payment-service  | 业务条线 - 支付服务  |spring boot + mysql |

#### 单体架构(主要是后端api)

在打包时打成一个包或是docker 容器运行在一个容器中时运行多个微服务 这两种方式来实现单体架构（TODO）。

注意： 为了boat-house维护简单，所以采用了一套代码库，在真实环境中不建议这样做。除非有特殊的运行场景需要。

#### 微服务架构(主要是后端api)

目前 boathouse-backend后台代码库 是使用spring boot按照微服务架构方式组织，如下图

![](images/boathouse-structure-product02.png)

## 工具指导文档

* [Selenium自动化UI测试](docs/quick-start/guide/selenium-ui-testing/Readme.md)
* [Jenkins调度Selenium](docs/quick-start/guide/selenium-for-jenkins/Readme.md)
* [Sonarqube配置指南](docs/quick-start/guide/sonarqube/Readme.md)
* [快速创建Junit测试](docs/quick-start/guide/junit-testing/Readme.md)
* [Nexus搭建指南](docs/quick-start/guide/nexus-deploy/Readme.md)
* [Nexus使用指南](docs/quick-start/guide/nexus-guide/Readme.md)
* [Postman接口测试指南](docs/quick-start/guide/postman-api-testing/Readme.md)
* [Azure快速搭建K8s环境](docs/quick-start/guide/k8s-azure/Readme.md)
* [Apollo介绍与docker部署](docs/quick-start/guide/apollo-config-center/Readme.md)
* [MetterMost OpsChat 配置](docs/quick-start/guide/chat-ops-metter-most/readme.md)
* [MetterMost OpsChat jenkins 集成](docs/quick-start/guide/chat-ops-metter-most/jenkins.md)
* [MetterMost OpsChat github 集成](docs/quick-start/guide/chat-ops-metter-most/github.md)
* [JMeter测试用例编写手册](docs/quick-start/guide/JMeter/Readme.md)
* [Jenkins集成Jmeter](docs/quick-start/guide/JMeter/jmeter--for-jenkins.md)
* [RESTful及RESTful API设计规范简介](docs/quick-start/guide/spec/restfull-api-design-spec.md)
* [k82mysql集群](docs/quick-start/guide/mysql-k8s-deploy/Readme.md)
* [使用 helm chart 部署 boat-house ](docs/quick-start/guide/k8s-helm-deploy-boat-house/README.md)
* [使用 Flyway 进行数据库持续交付](docs/quick-start/guide/java-flyway-db-pipeline/Readme.md)
* [Idea 快速创建Junit测试](docs/quick-start/guide/junit-testing/Readme.md)


## Contribute Guide：

##### 提交规范？

 - 格式：所有文档均需要使用Markdown的方式编写。

 - 存放：所有文档均需要在docs目录下创建一个文件夹用于存放图片以及文档，参考如下：

```csharp
devops-e2e-5p
	- 技术主题 (文件夹)
		- images (文件夹)
		- Readme.md (技术主题文档)
```


##### 文档原则：

 - 提交的每个文档需要能独立使用，不能与其他文档有依赖关系。
 - 文档需要包含详尽的内容以及截图，确保其他组成员按照文档完成DevOps相关的实践以及学习。
 - 如果文档中有脚本或代码，需要将脚本贴入Markdown，不要使用图片的方式。

