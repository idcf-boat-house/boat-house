# BHOL405 - k8s应用开发部署 - 使用Secrets保存和使用密钥信息

在这几节实验中，我们将完成我们的 Hello Boathouse 应用的k8s部署过程，其中会涉及到一下k8s中的对象

- Pod
- Deployment
- Service
- * Secret
- Namespace

这些内容基本上覆盖了我们k8s集群进行应用开发部署的主要对象。

## 01 - 实验准备

使用以下命令清理之前的部署：

```shell
kubectl delete -f kube-deploy/hello-boathouse-lb-service.yaml 
kubectl delete -f kube-deploy/hello-boathouse-nodeport-service.yaml
kubectl delete -f kube-deploy/hello-boathouse-deployment.yaml   
```

## 02 - 使用 Secrets 保存密钥信息

使用 secrets 我们可以将密钥信息保存在k8s集群中，并给到不同的pod使用。

使用 vscode 创建两个文件：

- hello-boathouse-secrets.yaml
- hello-boathouse-secrets-volumes.yaml

hello-boathouse-secrets.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secrets
type: Opaque
data:
  username: cm9vdA==
  password: cGFzc3dvcmQ=
```

hello-boathouse-secrets-volumes.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-boathouse-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-boathouse
  template:
    metadata:
      labels:
        app: hello-boathouse
    spec:
      containers:
      - name: hello-boathouse
        image: registry.cn-hangzhou.aliyuncs.com/boathouse216/hello-boathouse:v1
        ports:
        - name: nodejs-port
          containerPort: 3000
        volumeMounts:
        - name: cred-volume
          mountPath: /etc/creds
          readOnly: true
      volumes:
      - name: cred-volume
        secret: 
          secretName: db-secrets
```

使用以下命令提交部署

```shell
## 提交部署
kubectl apply -f kube-deploy/hello-boathouse-secrets
kubectl apply -f kube-deploy/hello-boathouse-secrets-volumes.yaml
## 检查部署结果
kubectl get secrets
kubectl get pods
```

使用以下命令进入其中一个pod查看 /etc/creds 内容

```shell
## 进入其中一个pod
kubectl exec {pod id} -it -- /bin/bash
cd /etc/creds
cat username
cat password
```

