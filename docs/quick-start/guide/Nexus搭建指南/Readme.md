### Docker 安装
sudo apt-get update
sudo apt install docker.io
sudo usermod -a -G docker {localadmin}


sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl daemon-reload
sudo systemctl restart docker 

### Nexus安装
https://hub.docker.com/r/sonatype/nexus3/

$ sudo mkdir nexus-data && chown -R 200 /nexus-data
$ docker run -d -p 8081:8081 -p:2020:2020 --name nexus -v /home/localadmin/nexus-data:/nexus-data sonatype/nexus3
获取密码
docker exec -it 0111e8b681e0 /bin/sh /opt/sonatype/sonatype-work/nexus3/admin.password  
![image.png](.attachments/image-1a907d26-bc94-4c66-8cc4-bb327293dedd.png)
添加仓库信任 

cat /lib/systemd/system/docker.service
ExecStart=/usr/bin/dockerd   --insecure-registry tools.devopshub.cn:2020

mac客户端
"insecure-registries": [
    "tools.devopshub.cn:2020"
  ],

sudo systemctl daemon-reload
sudo systemctl restart docker 

## 使用
docker login {IP}:2020 -u admin -p "{Password}"


安装nginx
mkdir -p /home/nginx/www /home/nginx/logs /home/nginx/conf

docker run -d -p 8082:8082 --name nginx -v /home/localadmin/nginx/conf/cert:/etc/nginx/cert -v /home/localadmin/ /nginx/www/:/usr/share/nginx/html -v /home/localadmin/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /home/localadmin/nginx/logs/:/var/log/nginx ngi nx