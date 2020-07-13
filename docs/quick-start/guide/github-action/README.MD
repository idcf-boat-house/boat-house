# github action使用教程

## 背景

为了改进jenkins需要搭建独立服务器，还需要专门的CI服务器进行打包的痛点。使用github action可以不用搭建专门的jenkins服务器，以及相应的CI服务器。github通过yml格式的文档就可以完成Jenkins server+CI server的所有功能。来达到减少维护量和服务器成本的目的。

## 已经实现的Github Action 流水线的仓库：

>Github Action 流水线配置文件只能存放在路径`.github/workflows/`中，否则不会Github Action引擎不会识别。

- 前端库：编译打包并部署至K8S测试环境，k8s命名空间为：boathouse-test-github
  - [client.yml](https://github.com/idcf-boat-house/boat-house-frontend/blob/master/.github/workflows/client.yml)
  - [management.yml](https://github.com/idcf-boat-house/boat-house-frontend/blob/master/.github/workflows/management.yml)
- 后端库：编译打包并部署至K8S测试环境，k8s命名空间为：boathouse-test-github
  - [account-service.yml](https://github.com/idcf-boat-house/boat-house-backend/blob/master/.github/workflows/account-service.yml)
  - [product-service.yml](https://github.com/idcf-boat-house/boat-house-backend/blob/master/.github/workflows/product-service.yml)
  - [statistics-service.yml](https://github.com/idcf-boat-house/boat-house-backend/blob/master/.github/workflows/statistics-service.yml)
- 安卓端：编译，并打包apk文件，暂未实现apk签名，并将APK上传至boat-house官网（TODO）
  - [android-client.yml](https://github.com/idcf-boat-house/boat-house-mobile-android/blob/master/.github/workflows/android-client.yml)
- boathouse 主库，将文档部署至azure app service 地址： http://idcf.org.cn/boat-house
  - [boat-house-docs-deploy.yml](https://github.com/idcf-boat-house/boat-house/blob/master/.github/workflows/boat-house-docs-deploy.yml)

## 功能说明

每个模块的yml文件中基本分为如下几步：

>注：以下脚本可能 并不是最新的，只是用来说明Yml结构,请以代码库中的yml脚本为准

* 触发器部分: 只对对应的目录push代码时才触发，如下所示：
    ```
    on: 
    push:
        paths:
        - 'src/client/**'
        - '.github/workflows/client.yml'
    ```
* 查看当前环境变量，用于调试和排错。
  ```
  - name: list env
        run: env
  ```
* 通过各自模块的dockerfile打包镜像
    ```
    - name: docker build client
        run: docker build -f src/client/Dockerfile -t docker.pkg.github.com/${GITHUB_REPOSITORY}/client:action-${GITHUB_REF##*/}-ci-${GITHUB_RUN_NUMBER} -t docker.pkg.github.com/${GITHUB_REPOSITORY}/client:action-ci src/client

    ```
* 登陆自己项目的github docker仓库
    ```
    - name: docker login
        run : docker login docker.pkg.github.com -u ${GITHUB_REPOSITORY%/*} -p ${{ secrets.packages_token }}
    ```
* 推送打包好的docker image到项目的仓库中
    ```
    - name: docker push client tag branch number
        run : docker push docker.pkg.github.com/${GITHUB_REPOSITORY}/client:action-${GITHUB_REF##*/}-ci-${GITHUB_RUN_NUMBER}
    ```
* 替换仓库机构、分支名、Build号和部署的k8s命名空间
    ```
    - name: replace github org name
         run: sed -i "s|#{BOATHOUSE_ORG_NAME}#|${GITHUB_REPOSITORY_OWNER}|g" devops/kompose/test/client-*.yaml

       - name: replace rep branch name
         run: sed -i "s|#{env.BRANCH_NAME}#|action-${GITHUB_REF##*/}-ci|g" devops/kompose/test/client-*.yaml

       - name: replace BUILD ID
         run: sed -i "s|#{env.BUILD_ID}#|${GITHUB_RUN_NUMBER}|g" devops/kompose/test/client-*.yaml

       - name: replace k8s namespace
         run: sed -i "s|#{DEPLOY_K8S_NAMESPACE_TEST}#|${{ secrets.DEPLOY_K8S_NAMESPACE_TEST }}|g" devops/kompose/test/client-*.yaml
    ```
* 设置k8s 对应的kube config和docker image 注册表帐号信息
    ```
    - uses: Azure/k8s-set-context@v1
         with:
           kubeconfig: ${{ secrets.KUBE_CONFIG }}

    - uses: Azure/k8s-create-secret@v1
         with:
           namespace: boathouse-test-github
           container-registry-url: docker.pkg.github.com
           container-registry-username: ${GITHUB_REPOSITORY%/*}
           container-registry-password: ${{ secrets.packages_token }}
           secret-name: regcred
    ```
* 将仓库中的docker image部署到对应的k8s集群的 `boathouse-test-github`
    ```
    - uses: Azure/k8s-deploy@v1
         with:
           namespace: 'boathouse-test-github'
           manifests: |
              devops/kompose/test/client-deployment.yaml
              devops/kompose/test/client-svc.yaml
           kubectl-version: 'latest'
    ```

## 使用方法

1. 在Github项目中找到: `Settings=>Sectets=>Add a new secret` 添加以下变量
   - PACKAGES_TOKEN: 填入带有packages授权的token,此token用于pull/push image时进行权限认证，目前线上环境采用acr。
       - 如果采用github的包管理保存Image，则应为github个人帐号的token，如何创建参考底部最后一个链接
       - 如果采用acr,请在自己的acr服务中找到密码，或者[从这里](https://github.com/idcf-boat-house/secret-files/blob/master/environment/readme.md)获取密码（仅限维护团队）
   - KUBE_CONFIG : kube 管理群集的配置文件，创建集群时生成，用于前面所说设置kube config, 通过此配置文件，流水线引擎才可以连接到对应的k8s集群(如果是维护团队，请从[这里](https://github.com/idcf-boat-house/secret-files/blob/master/k8s/kubeconfig/kubeconfig.chinanorth2.json)获取配置文件)
   - DEPLOY_K8S_NAMESPACE_TEST: k8s群集部署的命命名空间，独立命令空间，避免与其他流水线工具部署时产生冲突。github端值为： `boathouse-test-github`
   - BOATHOUSE_CONTAINER_REGISTRY： docker镜像仓库地址，值为： bhacr.azurecr.cn，使用 acr服务。
   - CREDS_GITHUB_REGISTRY_USR： bhacr

2. 在每次push代码时，github就会启动相应的yml对应的流程进行构建。可以点击项目的action进行过程查看。各github仓库的流水线地址如下：

- boathouse主库文档库： https://github.com/idcf-boat-house/boat-house/actions
- 前端：https://github.com/idcf-boat-house/boat-house-frontend/actions
- 后端：https://github.com/idcf-boat-house/boat-house-backend/actions
- Android端： https://github.com/idcf-boat-house/boat-house-mobile-android/actions


>注：目前Github Action 未提供手动触发机制，需通过代码提交的方式触发。

## TAG

注意由于项目中使用了Jenkins做编译打包，为了避免Github Action与Jenkins有冲突，所以我们在Github Action流水线打标签时添加了CI关键词,并且部署至一个独立的k8s环境命名空间（），Github Action当前实现了部署到测试环境中。不依赖jenkins。

## 参考文档
http://www.ruanyifeng.com/blog/2019/09/getting-started-with-github-actions.html
https://help.github.com/cn/packages/publishing-and-managing-packages/about-github-packages#about-tokens

