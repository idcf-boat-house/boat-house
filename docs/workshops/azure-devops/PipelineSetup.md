# 使用Azure Pipeline & Azure Kubernetes Service (AKS) 搭建BoatHouse流水线

## 创建aks集群

```shell
## 使用Azure CLI登录
az login
## 获取当前区域最新版的aks版本号
version=$(az aks get-versions -l <region> --query 'orchestrators[-1].orchestratorVersion' -o tsv)
```

## 创建acs镜仓库

## 搭建CI流水线

## 搭建CD流水线

