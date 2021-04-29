# Demo Script

## Demo Resource -- PreConfigured

预搭建的Jenkins服务器：
ssh ghuser@pmdmwspu1039.chinanorth2.cloudapp.chinacloudapi.cn
Zh6E92RP
http://pmdmwspu1039.chinanorth2.cloudapp.chinacloudapi.cn:8080


Dev环境 
ssh ghuser@wwkqbgsx1040.chinanorth2.cloudapp.chinacloudapi.cn
CsFwfM1X
http://wwkqbgsx1040.chinanorth2.cloudapp.chinacloudapi.cn:5000
http://wwkqbgsx1040.chinanorth2.cloudapp.chinacloudapi.cn:5001
http://wwkqbgsx1040.chinanorth2.cloudapp.chinacloudapi.cn:7001/api/v1.0/swagger-ui.html

K8s环境
az aks get-credentials -g lx-boathouse-aks-rg01 -n bhaks01

## Demo Resource -- DEMO

预搭建的Jenkins服务器：
ssh ghuser@krrgzuhe1042.chinanorth2.cloudapp.chinacloudapi.cn

http://krrgzuhe1042.chinanorth2.cloudapp.chinacloudapi.cn:8080 

Dev环境 
ssh ghuser@nygyerha1045.chinanorth2.cloudapp.chinacloudapi.cn

http://nygyerha1045.chinanorth2.cloudapp.chinacloudapi.cn:5000
http://nygyerha1045.chinanorth2.cloudapp.chinacloudapi.cn:5001
http://nygyerha1045.chinanorth2.cloudapp.chinacloudapi.cn:7001/api/v1.0/swagger-ui.html

K8s环境
az aks get-credentials -g bhdemo0429-rg -n bhdemo0429cluster

## Demo 1 - 使用DevOps实验室创建虚拟机

Ubuntu Linux 16.04 LTS	邀请码试用	bbb4b575	true

https://labs.devcloudx.com/templates

## Demo 2 - Gitee上创建组织并Fork代码库

## Demo 3准备 - 初始化Jenkins服务器并导入前后端流水线

```shell
## 演示前完成以下操作，确保jenkins处于可用状态

## ssh登录
ssh ghuser@krrgzuhe1042.chinanorth2.cloudapp.chinacloudapi.cn

## 安装docker环境
sudo apt-get update
sudo apt install docker.io
sudo usermod -a -G docker ghuser
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl daemon-reload
sudo systemctl restart docker 

sudo groupadd docker 
sudo gpasswd -a $USER docker 
newgrp docker 

## 安装jenkins

sudo mkdir ~/jenkins_home 
sudo chown -R 1000:1000 ~/jenkins_home
sudo docker run -d -p 8080:8080 -p 50000:50000 --env JAVA_OPTS=-Dhudson.model.DownloadService.noSignatureCheck=true -v ~/jenkins_home:/var/jenkins_home -u 0 jenkins/jenkins:lts
docker ps

## 获取jenkins初始密码并完成基础插件的安装
sudo cat jenkins_home/secrets/initialAdminPassword

## 安装java环境
sudo apt-get install openjdk-8-jdk
java -version
sudo apt install maven

## 设置面密码sudoer

sudo usermod -aG sudo ghuser
sudo vim /etc/sudoers
## /etc/sudoers文件最末尾添加下面代码：
ghuser ALL=(ALL) NOPASSWD:ALL

## 设置当前机器为vm-slave节点

mkdir jenkins_workspace
cd jenkins_workspace
touch test
ls
## Labels=vm-slave
## Remote root directory	/home/ghuser/jenkins_workspace

## 安装以下插件
Cobertura、Kubernetes Continuous Deploy、SSH Pipeline、Blue Ocean


## 完成以下全局变量和credental的设置

BOATHOUSE_CONTAINER_REGISTRY	tgjwkats1044.azurecr.cn
CREDS_GITHUB_REGISTRY_USR	tgjwkats1044
CREDS_GITHUB_REGISTRY_PSW	dWPA9h/r61XDQHNQyTAAcB0ZUL5mH7yV
BOATHOUSE_DEV_HOST	nygyerha1045.chinanorth2.cloudapp.chinacloudapi.cn
BOATHOUSE_ORG_NAME	idcf-boat-house	
DEPLOY_K8S_NAMESPACE_TEST	boathouse-test	
DEPLOY_K8S_NAMESPACE_PROD	boathouse-prod	

```

## Demo 3 - 初始化Jenkins服务器并导入前后端流水线

1. 登录Jenkins
2. 进入 Blue Ocean
3. 导入 gitee boat-house-backend 库地址
4. 配置 jenkins file path devops/jenkins/jenkinsfile
5. 启动流水线

## Demo 4 - 部署到k8s集群

kubectl create namespace boathouse-test
kubectl create namespace boathouse-prod
kubectl create secret docker-registry regcred --docker-server=tgjwkats1044.azurecr.cn --docker-username=tgjwkats1044 --docker-password=dWPA9h/r61XDQHNQyTAAcB0ZUL5mH7yV --docker-email=info@idcf.io -n boathouse-test
kubectl create secret docker-registry regcred --docker-server=tgjwkats1044.azurecr.cn --docker-username=tgjwkats1044 --docker-password=dWPA9h/r61XDQHNQyTAAcB0ZUL5mH7yV --docker-email=info@idcf.io -n boathouse-prod

watch kubectl get pods -n boathouse-test
watch kubectl get svc -n boathouse-test