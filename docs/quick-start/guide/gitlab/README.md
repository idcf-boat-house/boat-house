# 搭建 GitLab 服务器

ref: https://docs.gitlab.com/omnibus/docker/

```shell
export GITLAB_HOME=/srv/gitlab
docker-compose -f docker-compose-gitlab.yaml up -d
```