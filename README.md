# IDCF 社区共创文档库

## IDCF 社区共创介绍

* [项目概念](docs/quick-start/operation/项目概述.md)
* [项目组成员](docs/quick-start/operation/项目组成员.md)
* [迭代计划](docs/quick-start/operation/迭代计划.md)
* [会议摘要](docs/quick-start/operation/会议摘要.md)
* [项目直播](docs/quick-start/operation/项目直播.md)
* [技术支持](docs/quick-start/operation/技术支持.md)


**Contributing**

* [项目协作流程](docs/quick-start/operation/项目协作流程.md)
* [团队上手指南](docs/quick-start/operation/团队上手指南.md)
* [项目基础环境介绍](docs/quick-start/operation/项目基础环境介绍.md)
* [快速开发指南](docs/quick-start/operation/快速开发指南.md)
* [开发规范](docs/quick-start/operation/开发规范.md)
* [验收标准（AC）](docs/quick-start/operation/验收标准（AC）.md)
* [完成标准（DoD）](docs/quick-start/operation/完成标准（DoD）.md)
* [团队代码合并指南](docs/quick-start/operation/团队代码合并指南.md)

## IDCF 相关存储库介绍

### boat-house: 主库(本库)

主要存放基于Boat-house代码库的种实践文档，整个boat-house的共创运作基于此库展开。

**IDCF boat-house 主库目录结构**

- docs
	- quick-start
	- lean
	- agile-team
	- agile-scaled
	- devops-e2e-5p
	- devops-hackathon
		-workshop
	- devops-case-studies

##### 主库文档查看地址

 http://idcf.org.cn/boat-house

### 单体架构相关代码库

- [boathouse-frontend: 前端代码库]()
- [boathouse-mobile-android: 客户端代码库]()
- [boathouse-backend：后台代码库]()

### 微服务架构相关代码库

复用用单体架构仓库，分开打包。

## 工具指导文档

* [Selenium自动化UI测试](docs/quick-start/guide/Selenium自动化UI测试/Readme.md)
* [Jenkins调度Selenium](docs/quick-start/guide/Jenkins调度Selenium/Readme.md)
* [Sonarqube配置指南](docs/quick-start/guide/Sonarqube配置指南/Readme.md)
* [快速创建Junit测试](docs/quick-start/guide/快速创建Junit测试/Readme.md)
* [Nexus搭建指南](docs/quick-start/guide/Nexus搭建指南/Readme.md)
* [Nexus使用指南](docs/quick-start/guide/Nexus使用指南/Readme.md)
* [Postman接口测试指南](docs/quick-start/guide/Postman接口测试指南/Readme.md)
* [Azure快速搭建K8s环境](docs/quick-start/guide/Azure快速搭建K8s环境/Readme.md)
* [Apollo介绍与docker部署](docs/quick-start/guide/Apollo介绍与docker部署/Readme.md)

## Contribute Guide：

##### 提交规范？

 - 格式：所有文档均需要使用Markdown的方式编写。

 - 存放：所有文档均需要在docs目录下创建一个文件夹用于存放图片以及文档，参考如下：

```csharp
docs
	- 技术主题 (文件夹)
		- images (文件夹)
		- Readme.md (技术主题文档)
```


##### 文档原则：

 - 提交的每个文档需要能独立使用，不能与其他文档有依赖关系。
 - 文档需要包含详尽的内容以及截图，确保其他组成员按照文档完成DevOps相关的实践以及学习。
 - 如果文档中有脚本或代码，需要将脚本贴入Markdown，不要使用图片的方式。

