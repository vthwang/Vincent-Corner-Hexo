---
title: docker 快速學習自我挑戰 Day8
thumbnail:
  - /blogs/images/learning/docker/dockerday8.png
date: 2017-08-02 13:54:52
categories: 學習歷程
tags: Docker
---
<img src="/blogs/images/learning/docker/dockerday8.png">

***
### Container Registry：Image Storage and Distribution
#### Docker Hub：探尋的更深入
##### Container Registries
1. 你的 Container plan 需要有 Image Registry 成為 plan 的一部分
2. 更多 Docker Hub 的細節，包含 auto-build
3. Docker Store 是怎麼樣跟 Hub 不一樣
4. Docker Cloud 是怎麼樣跟 Hub 不一樣
5. 使用 Cloud 的新 Swarm 功能來讓 Mac/Win 跟 Swarm 連線
6. 安裝和使用 Docker Registry，且當作 private image store
7. 第三方 registry 套件選項
##### Docker Hub：探尋的更深入
1. 最有名的 public image registry
2. 它是真的 Docker Registry 而且最輕量的 image building
3. 讓我們探索更多 Docker Hub 的功能
4. 連結 GitHub/BitBucket 到 Hub 而且自動建立 images commit
5. 將 image building 串連在一起
#### Docker Store：它可以做什麼？
1. 下載 Docker "Editions"
2. 找到認證過的 Docker/Swarm 外掛和商業認證的 images
#### Docker Cloud：CI/CD 和 Server Ops
1. Web based Docker Swarm 創建/管理
2. 使用有名的雲端主機商和自建式伺服器
3. 自動化的 image building、測試和部署
4. 跟 Docker Hub 免費的東西相比更進階
5. 包含 image 安全掃描服務
#### 使用 Docker Cloud 來做簡單的遠端 Swarm 管理 
1. [觀看此影片](https://www.youtube.com/watch?v=VJmbCioYKGg)
#### 了解 Docker Registry
1. 一個提供給你的網路的私有 image registry
2. Docker/Distribution Github Repo 的一部分
3. 事實上在私有的 container registry
4. 不像完整功能的 Hub 或其它東西，它沒有完整的網頁介面，只有基本的認證
5. 在核心的部分：一個網頁的 API 和儲存系統，用 Go 語言撰寫
6. 儲存系統支援 local、S3/Azure/Alibaba/Google 雲，還有 OpenStack Swift
7. 查看以下資源：
    - [使用 TLS 加密你的 Registry](https://docs.docker.com/registry/configuration/)
    - [透過 Garbage Collection 來進行儲存清理](https://docs.docker.com/registry/garbage-collection/)
    - [透過 "--registry-mirror" 開啟 Hub caching](https://docs.docker.com/registry/recipes/mirror/)
#### 運行一個私有的 Docker Registry
1. 運行 registry image 在預設 port 5000
2. Re-tag 已存在的 image，且推送它到你的新 registry
3. 從本地端 cache 移除 image，且從新的 registry pull 下來
4. 使用 bind mount 來 Re-create registry，且觀察它如何儲存資料
##### Registry 和適合的 TLS
1. 「預設加密」：Docker 不會用沒有 HTTPS 的方式跟 registry 溝通，除了 localhost (127.0.0.0/8)
2. 對於遠端自行登入的 TLS，要再引擎啟動 「insecure-registry」
3. 運行私有 registry image
    - `docker container run -d -p 5000:5000 --name registry registry`
4. `docker pull hello-world` 下載很輕量的 image 來測試
5. Re-tag 已存在的 image，且推送它到你的新 registry
    - `docker tag hello-world 127.0.0.1:5000/hello-world`
    - `docker push 127.0.0.1:5000/hello-world`
6. 從本地端 cache 移除 image，且從新的 registry pull 下來
    - `docker image remove hello-world`
    - `docker image remove 127.0.0.1:5000/hello-world`
    - `docker pull 127.0.0.1:5000/hello-world`
7. `docker container kill registry`
8. `docker container rm registry`
9. 使用 bind mount 來 Re-create registry，且觀察它如何儲存資料
    - `docker container run -d -p 5000:5000 --name registry -v $(pwd)/registry-data:/var/lib/registry registry`
    - `docker push 127.0.0.1:5000/hello-world`
    - `tree registry-data`
#### 安裝 Docker 自動完成
1. [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/docker)
2. [docker-zsh-completion](https://github.com/felixr/docker-zsh-completion)
#### 作業：使用 TLS 和認證加密 Docker Registry
1. 透過創建給 HTTPS 的 self-signed 認證和啟動 **htpasswd** 認證可以學習到基礎
2. 會使用 Play With Docker 來完成這個作業
3. 建議使用 [Part 2 and 3 of "Docker Registry for Linux](http://training.play-with-docker.com/linux-registry-part2/) 來完成作業，或是跳回 [Part 1](http://training.play-with-docker.com/linux-registry-part1/) 且在他們的 infrastructure 上運行 container，使用他們的實際 Docker Engine 的 web-based 介面學習 **PWD** 怎麼運作的
4. 更多實驗請參考：[點此](http://training.play-with-docker.com/)
#### 跟 Swarm 一起使用 Registry
1. 跟 localhost 用一樣的方式
2. 由於 Routing Mesh，所有的節點可以在 127.0.0.1:5000 被看到
3. 記得決定如何儲存 image (volume driver)
4. 筆記：所有的 nodes 都要可以存取 images
5. 專業的技巧：如果可以的話，使用 hosted SaaS registry
##### 使用 play-with-docker.com
1. `docker service create --name registry --publish 5000:5000 registry`
2. 在 5000 port 的 console 後面加上 v2/_catalog 可以看到 json 格式的紀錄
3. `docker pull hello-world`
4. `docker tag hello-world 127.0.0.1:5000/hello-world`
5. `docker push 127.0.0.1:5000/hello-world`
6. 在 5000 port 的 console 後面加上 v2/_catalog 可以看到 `{"repositories":["hello-world"]}`
7. `docker pull nginx`
8. `docker tag nginx 127.0.0.1:5000/nginx`
9. `docker push 127.0.0.1:5000/nginx`
10. `docker service create --name nginx -p 80:80 --replicas 5 --detach=false 127.0.0.1:5000/nginx`
11. `docker service ps nginx` 就可以看到它使用的是本機端的 image **(127.0.0.1:5000/nginx:latest)**
#### Docker 的第三方套件
1. 最流行的是：[Quay.io](https://quay.io/)
2. 如果使用 [AWS](https://www.docker.com/enterprise-edition#/container_management)、[Azure](https://azure.microsoft.com/en-us/services/container-registry/)、[Google Cloud](https://cloud.google.com/container-registry/)，他們都有自己專屬的 registry
3. 如果是自建式主機，[Docker EE](https://www.docker.com/enterprise-edition#/container_management)、[Quay Enterprise](https://quay.io/plans/?tab=enterprise)、[GitLab](https://about.gitlab.com/2016/05/23/gitlab-container-registry/)
4. 更多詳細的 [registry 清單](https://github.com/veggiemonk/awesome-docker#hosting-images-registries)