---
title: Docker 快速學習自我挑戰 II Day4
thumbnail:
  - /images/learning/docker-2/DockerDay04.jpg
date: 2019-06-02 20:45:09
categories: 學習歷程
tags: Docker
---
<img src="/images/learning/docker-2/DockerDay04.jpg">

***
### 容器的操作
1. 使用 exec 操作容器
`docker exec -it 5af6cbcc10e9 python`
`docker exec -it 5af6cbcc10e9 ip a`
2. 停掉容器 `docker stop [id]`
3. 刪除所有退出的容器 `docker rm $(docker ps -aq)`
4. 啟動容器 `docker start [id]`
5. 查看容器信息 `docker inspect [id]`
6. [Container 的所有命令](https://docs.docker.com/engine/reference/commandline/container/)






