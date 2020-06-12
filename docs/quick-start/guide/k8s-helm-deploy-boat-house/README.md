使用 helm chart 部署 boat-house 可以更简便；同时，维护 yaml 时，无需针对多套环境维护多套。

使用 helm chart 部署 boat-house 分为两步：

部署基础设施
ENV=test
kubectl create namespace boathouse-$ENV
helm install infra ./kompose/chart --namespace boathouse-$ENV \
        --set "services={product-service-db,statistics-service-db,statistics-service-redis},imageTag=master-86"

# 跟踪部署进度，等待 product-service-db 部署完成后导入初始数据
kubectl rollout status deploy/product-service-db -n boathouse-$ENV

PRODUCT_DB_POD=$(kubectl get pods -o=jsonpath='{.items[0].metadata.name}' -l app=product-service-db)
sleep 5
kubectl cp ./product-service/api/scripts/init.sql ${PRODUCT_DB_POD}:/root/init.sql -n boathouse-$ENV -c product-service-db
kubectl exec ${PRODUCT_DB_POD} -c product-service-db -n boathouse-$ENV -- /bin/bash -c 'mysql -u root -pP2ssw0rd < /root/init.sql'
部署或更新微服务
ENV=test
TAG=master-86
# 如果只想部署或升级某一个微服务，把它的名字放在这里；否则将部署或升级所有微服务
SERVICES=

EXISTING=$(helm list --filter services -n boathouse-$ENV --short)
if [ -z "$EXISTING" ]; then
    helm install services ./kompose/chart --namespace boathouse-$ENV --set "services=$SERVICES,imageTag=$TAG"
else 
    helm upgrade services ./kompose/chart --namespace boathouse-$ENV --set "services=$SERVICES,imageTag=$TAG"
fi
