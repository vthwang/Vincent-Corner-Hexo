---
title: docker 快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/docker/dockerday1.png
date: 2017-07-23 02:55:38
categories: Study Note
tags: Docker
---
<img src="/images/learning/docker/dockerday1.png">

***
### 課程 Roadmap
#### Part I
1. Install Docker
2. Terminal/CLI Tools
3. Download the Repo (github)
#### Part II
1. CURD of Containers
2. Just A Process
3. Shell into Container
4. Docker Networking
#### Part III
1. Use Docker Hub
2. Make Dockerfiles
3. Push Custom Images
4. Build Images
#### Part IV
1. Container Lifetime
2. Docker Volumes
3. Build Mounts
#### Part V
1. Do's and Don'ts
2. docker-compose.yml
3. docker-compose up
#### Part VI (BIG ONE)
1. Build A Cluster
2. Overlay Networks
3. Routing Mesh
4. Swarm Services
5. Stacks
6. Secrets
7. App Deploy Lifecycle
### 安裝與版本
#### 安裝
1. [Win10](https://www.docker.com/docker-windows)
2. [Win8.1 以前的版本](https://www.docker.com/products/docker-toolbox) 
注意：範例所使用的 http://localhost，必須要改為 http://192.168.99.100
3. [Mac](https://www.docker.com/docker-mac)，如果使用低於版本 OSX Yosemite 10.10.3，改用 [Toolbox](https://www.docker.com/products/docker-toolbox)
4. 千萬不要使用 `apt/yum install docker`，請使用自動化安裝 `curl -sSL https://get.docker.com/ | sh`
#### 版本
1. Docker Engine 現在改為 Docker CE (Community Edition)
2. Docker Data Center 現在改為 Docker EE (Enterprise Edition)
3. Docker 的版本改為 `YY.MM` 的命名方式
### 創建和使用 Container
#### 檢查 Docker 的安裝和設定
1. `docker version` 檢查版本
Client 的版本是 Command Line 的版本，Server 則被稱為 docker engine，docker engine 是在背景執行的 daemon，而我們執行的 Command Line 就跟伺服器的 API 來進行溝通，
2. `docker info` 取得更詳細的資訊
3. docker 指令格式 `docker <command> <sub-command> (options)`
#### 開始使用 Nginx Server
1. Image 是我們想要跑的應用程式
2. Container 是 image 所產生的 instance，並用進程的方式執行
3. 可以使用同個 image 來產生很多 Container
4. `docker container run --publish 80:80 nginx` 新建 ngix server，執行完成之後可以直接用瀏覽器看到 nginx，語法背後執行的邏輯如下：
    - 從 Docker Hub 下載「nginx」的 image
    - 從這個 image 開始一個新的 container
    - 開啟本機端的 80 port
    - 將 80 port 路由到 container 的 80 port
5. `docker container run --publish 80:80 --detach nginx` 加上 detach 可以讓 docker 在背景執行，這個指令會 echo 出 container ID
6. `docker container ls` 列出所有的 container
7. `docker container stop 889` 停止某個 container，stop 後面加上 id 前三碼 (只要是唯一即可，若三碼非唯一，則用四碼，後面以此類推)
8. `docker container ls -a` 列出所有(包含關閉的) container
9. 當使用 `run` 的時候，一定會新增新的 container，但是當使用 `start` 的時候，則會開啟一個存在但關閉的 container
10. `docker container run --publish 80:80 --detach --name webhost nginx` 新增客製化名稱的 container
11. `docker container logs webhost` 檢查 container 名稱為「webhost」的 log 檔
12. `docker container top webhost` 檢查 container 名稱為「webhost」的 process
13. `docker container rm 2e5 889 dc1` 刪除所選的 container
14. 如果有在執行中的 container，則要強制刪除 `docker container rm -f 2e5`
#### "docker container run" 做了什麼事情？
1. 在本地 image cache 搜尋 image
2. 如果找不到，則搜尋遠端的 image repository (預設為 Docker Hub)
3. 下載最新版本 (nginx：預設為最新版，可以使用 nginx:版本號來取得所需版本)
4. 根據拿到的 image 來創建新的 container，並準備開始
5. 在 docker engine 裡面給 container 私有網路上的虛擬 ip
6. 開啟 host 端的 80 port 並轉址到 container 的 80 port，如果沒有使用 `--publish` 則不會打開任何 port
7. 藉由使用 image Dockerfile 裡的 **CMD** 開啟 container
8. `docker container run --publish 8080:80 --name webhost -d nginx:1.11 nginx -T`
    - host port 可以改為 8080
    - 可修改 nginx 的版本為 1.11  
    - `nginx -T` 修改開啟時的 CMD
#### Container VS. VM
1. Container 不是縮小版的 VM
    - Container 只是 Process
    - Container 能夠存取的資源有限
    - 當 Process 暫停的時候離開
2. 用命令提示字元了解更多
    - `docker run --name mongo -d mongo` 新建一個 mongo DB 的 container 並在背景執行
    - `ps aux` 檢視所有正在執行的程式，`docker top mongo` 檢視服務的狀態
    - `ps aux | grep mongo` 搜尋 mongo 的服務
    - `docker stop mongo` 關閉 mongo，檢視和搜尋都會找不到該服務
    - `docker start mongo` 再次打開 mongo，檢視和搜尋都又會再找到該服務