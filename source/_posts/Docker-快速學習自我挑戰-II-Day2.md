---
title: Docker 快速學習自我挑戰 II Day2
thumbnail:
  - /images/learning/docker-2/DockerDay02.png
date: 2019-05-22 11:35:09
categories: 學習歷程
tags: Docker
---
<img src="/images/learning/docker-2/DockerDay02.png">

***
### Docker 的架構和底層技術
#### Docker Platform
1. Docker 提供了一個開發，打包，運行 App 的平台
2. 把 App 和底層 Infrastructure 隔離開來
#### Docker Engine
1. Docker Engine 是 Docker 最重要的組件
2. 後台進程（dockerd），提供了 REST API Server，還有 CLI 接口
3. 在虛擬機裡面可以看 Docker 版本
`sudo docker version`
4. 看 Docker 後台運行的狀態
`ps -ef | grep docker`
#### Docker 底層技術支持
1. Namespaces：做隔離 pid, net, ipc, mnt, uts
2. Control groups：做資源限制
3. Union file systems: Container 和 Image 的分層
### Docker Image 概述
#### Image 概述
1. Image 使用的架構

<img src="/images/learning/docker-2/DockerDay02-Image01.jpg">

2. 文件和 meta data 的集合（root filesystem）
3. 分層的，並且每一層都可以添加改變刪除文件，成為一個新的 Image
4. 不同的 Image 可以共享相同的 layer
5. Image 本身是唯讀的
#### Image 實作
1. 列出現在有的 docker image
`sudo docker image ls`
2. Image 的獲取
    - 用 Dockerfile 建立
    - 從 Registry 拉取
        - `sudo docker pull ubuntu:14.04`
        - `sudo docker image ls`
3. 去掉 sudo，因為每次都要打 sudo 很不方便
    - 新增 docker 的 group `sudo groupadd docker`，會顯示已經存在，所以可以不用新增
    - 新增用戶到 docker group 裡面 `sudo gpasswd -a vagrant docker`
    - 重啟 docker 服務 `sudo service docker restart`
    - 退出虛擬機 `exit`
    - 再次進入就可以不用 sudo 權限執行 docker `vagrant ssh`
### 製作 Base Image
1. 下載 Hello World `docker pull hello-world`
2. 執行 Hello World Container `docker run hello-world`
3. 新增一個資料夾 `mkdir hello-world`
4. 新增一個 hello.c `vim hello.c`
```
#Include<studio.h>

int main() {
  printf("hello docker\n");
}
```
5. 安裝 C 語言編譯相關套件
`sudo apt-get install gcc`
`sudo apt-get install build-essential`
6. 編譯 Hello.c，輸出可執行文件 hello
`gcc -static hello.c -o hello`
7. 執行 hello
`./hello`
8. 新增 Dockerfile `vim Dockerfile`
```
FROM scratch
ADD hello /
CMD ["/hello"]
```
9. -t 指定 tag，用 docker id + image 的名字，在最後面加個 . 表示在當前目錄找 Dockerfile
`docker build -t fishboneapps/hello-world .`
10. 透過 docker history 來看分層
`docker history fishboneapps/hello-world:latest`
11. 運行 image，如果返回 hello docker 代表這個 image 是可以當作 container 去執行的
`docker run fishboneapps/hello-world`
### 認識 Container
#### 什麼是 Container?
1. 透過 Image 創建
2. 在 Image layer 之上建立一個 container layer（可讀寫）
3. 可以把 Image 理解成 class，而 Container 是運行實例
4. Image 是負責儲存和分發的，而 Container 是負責運行 app
#### Container 實作
1. 列出所有 Container
`docker container ls`
2. 列出當前所有容器，包含正在運行以及退出的
`docker container ls -a`
3. 運行 `docker run centos` 會發現什麼都沒有，接下來執行 `docker container ls` 也會發現什麼都沒有
4. 但是運行 `docker container ls -a` 就會發現 centos 的 container 退出了
5. 運行之後，會發現進入一個操作系統，-i 就是交互式，讓 docker 持續開啟，就算沒有連結，-t 就是 tty，就是連線到 Container 裡面
`docker run -it centos`
6. 再運行 `docker container ls` 就會發現出現了 centos
7. `docker container ls -a` 等於 `docker ps -a`
8. `docker container rm ....` 等於 `docker rm`
9. `docker image ls` 等於 `docker images`
10. `docker image rm` 等於 `docker rmi`
11. 列出所有關閉的 Container
`docker container ls -aq`
`docker container ls -a | awk {'print$1'}`
12. 刪除所有 Container
`docker rm $(docker container ls -aq)`
13. 列出所有退出的 Container
`docker container ls -f "status=exited"`
14. 列出所有退出 Container 的標頭
`docker container ls -f "status=exited" -q`
15. 刪除所有退出的 Container
`docker rm $(docker container ls -f "status=exited" -q)`
### 建立自己的 Docker Image
#### 用 Container 建立 Docker Image
1. 運行 centos image
`docker run -it centos`
2. 在 container 裡面安裝 vim
`yum install -y vim`
3. 列出所有 container，要找到 container 的名字
`docker container ls -a`
4. 把 container 轉存成 image
`docker commit upbeat_albattani fishboneapps/centos-vim`
5. 以上方法是比較不建議的方式
#### 用 Dockerfile 建立 Docker Image
1. 建立一個目錄
`mkdir docker-centos-vim`
2. 進入目錄並新增 Dockerfile
`cd docker-centos-vim && vim Dockerfile`
3. 新增 Dockerfile
```
FROM centos  // 基於 centos 的 Docker
RUN yum install -y vim  // 運行指令
```
4. 建立 Image
`docker build -t fishboneapps/centos-vim-new .`
5. 在生成 Image 的時候，最好通過 Dockerfile 一步一步的去生成，這樣我們只需要去分享 Dockerfile 給別人就好了，別人通過分享的 Dockerfile，就可以生成一模一樣的 Image 了。