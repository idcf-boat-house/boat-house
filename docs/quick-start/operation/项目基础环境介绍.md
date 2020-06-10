BoatHouse项目使用微软Azure作为基础环境搭建的云平台，通过使用Azure提供的DevTest Labs作为共创项目的基础环境管理平台，实现云环境资源的更高效的利用和管理。通过将本地AD与Azure AD集成，实现用户的单点登陆。
目前的网络架构图：

![image.png](images/IDCPSNetwork.png)

## 环境说明

目前启用三台Ubuntu虚拟机和一套k8s集群。
对于资源的规划：

1.GitHub Enterprise（暂未启用）

2.Jenkins集群

3.工具链相关软件

4.一个双节点的k8s集群


#### 所有软件目前都是用容器方式安装，对于某些工具，比如Jmeter，可以按需扩容。















