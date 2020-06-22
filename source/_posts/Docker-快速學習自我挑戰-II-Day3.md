---
title: Docker 快速學習自我挑戰 II Day3
thumbnail:
  - /images/learning/docker-2/DockerDay03.png
date: 2019-05-31 11:19:45
categories: Study Note
tags: Docker
toc: true
---
<img src="/images/learning/docker-2/DockerDay03.png">

***
### Dockerfile 語法梳理與最佳實踐
#### Dockerfile 語法
1. FROM 語法：為了安全，盡量使用官方的 Image 作為 Base Image
    - `FROM scratch` 製作 Base Image
    - `FROM centos` 使用 Base Image
    - `FROM ubuntu:14.04`
2. Label 語法：Metadata 不可少，可以理解成註釋
    - `LABEL maintainer="vincent@fishboneapps.com"`
    - `LABEL version="1.0"`
    - `LABEL description="This is the description"`
3. RUN 語法：為了美觀，複雜的 RUN 用反斜線換行！避免無用分層，合併多條命令成一行！
```
RUN yum update && yam install -y vim \
python-dev # 反斜線換行
```
```
RUN apt-get update && apt-get install -y perl \
pwgen --no-install-recommends && rm -rf \
/var/lib/apt/lists/* # 注意清理 cache
```
```
RUN /bin/bash -c 'source $HOME/.bashrc; echo $HOME
```

4. WORKDIR 語法：用 WORKDIR，不要用 RUN cd！盡量使用絕對目錄
```
WORKDIR /root
```
```
WORKDIR /test # 如果沒有會自動創建 test 目錄
WORKDIR demo
RUN pwd # 輸出結果是 /test/demo
```

5. ADD 和 COPY 語法：大部分情況，COPY 比 ADD 好，ADD 除了 COPY 的功能以外，還有額外的解壓縮功能。添加遠端文件/目錄要使用 curl 或者 wget。
```
ADD hello / # 將本地的檔案傳到 Image 裡面
```
```
ADD test.tar.gz / # 添加到根目錄並解壓
```
```
WORKDIR /root
ADD hello test/ # /root/test/hello
```
```
WORKDIR /root
COPY hello test/ # /root/test/hello
```

6. ENV 語法：盡量使用 ENV 增加可維護性
```
ENV MYSQL_VERSION 5.6 # 設置常量
RUN apt-get install -y mysql-server = "${MYSQL_VERSION}" \
    && rm -rf /var/lib/apt/lists/* # 引用常量
```

7. VOLUME 和 EXPOSE 語法：儲存和網路，後面單獨講。
8. CMD 和 ENTRYPOINT 語法：後面單獨講。
9. [Docker 語法參考網址](https://docs.docker.com/engine/reference/builder)
#### RUN vs. CMD vs. ENTRYPOINT
1. 語法說明
    - RUN：執行命令並創建新的 Image Layer
    - CMD：設置容器啟動後默認執行的命令和參數
    - ENTRYPOINT：設置容器啟動時運行的命令
2. SHELL 和 Exec 格式
SHELL 格式
```
RUN apt-get install -y vim
CMD echo "hello docker"
ENTRYPOINT echo "hello docker"
```
Exec 格式
```
RUN [ "apt-get", "install", "-y", vim ]
CMD [ "/bin/echo", "hello docker" ]
ENTRYPOINT [ "/bin/echo", "hello docker" ]
```

3. 兩種 Dockerfile 格式
SHELL 格式
```
FROM centos
ENV name Docker
ENTRYPOINT echo "hello $name"
```
Exec 格式
```
FROM centos
ENV name Docker
ENTRYPOINT [ "/bin/echo", "hello $name" ]
```

4. CMD 語法
    - 容器啟動時默認執行的命令
    - 如果 docker run 指定了其它命令，CMD 命令被忽略
    - 如果定義了多個 CMD，只有最後一行會執行
5. ENTRYPOINT 語法
    - 讓容器以應用程序或者服務的形式運行
    - 不會被忽略，一定會執行
    - 最佳實踐：寫一個 shell 腳本作為 entrypoint
```
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh]

EXPOSE 27017
CMD ["mongod"]
```
### 鏡像的發佈
1. `docker login` 登入 Docker Hub 帳號
2. `docker push fishboneapps/hello-world:latest` 上傳到遠端倉庫
3. `docker pull fishboneapps/hello-world` 從遠端倉庫拉回本地
4. 推薦的方式是透過 Github 去做關聯，然後只要維護在 Github 上面的 Dockerfile，最後 Docker Hub 會自動幫我們做 build
#### 搭建私有的 Registry
1. 如果想要架設私有的 Docker Hub，可以使用 [Registry](https://hub.docker.com/_/registry)
2. 安裝 Registry
`docker run -d -p 5000:5000 --restart always --name registry registry:2`
3. 在本地重新 build Image
`docker build -t [ip]:5000/hello-world .`
4. 如果直接 push，會顯示有安全性問題，所要先在 /etc/docker 裡面新增 daemon.json
`vim /etc/docker/daemon.json`
```
{
  "insecure-registries": ["[ip]:5000"]
}
```
5. 然後再修改 /lib/systemd/system/docker.service，在裡面新增一行 EnvironmentFile
```
...
ExecStart=/usr/bin/docerd
EnvironmentFile=-/etc/docker/daemon.json
ExecReload=/bin/kill -s HUP $MAINPID
...
```
6. 重啟 docker `sudo service docker restart`
7. 上傳到遠端 Registry `docker push [ip]:5000/hello-world`
8. 因為 Registry 沒有 Web 介面，所以可以使用 [Docker Registry API](https://docs.docker.com/registry/spec/api/) 來驗證上傳是否成功
### Dockerfile 實戰
#### 測試運行 python flask
1. 新增 app.py
```
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return "hello docker"
if __name__ == '__main__':
	  app.run()
```
2. 安裝 python `sudo apt-get install -y python2.7`
3. 安裝 python-pip `sudo apt-get install -y python-pip`
4. 安裝 flask `pip install flask`
5. 如果遇到 locale 問題，可以使用以下指令
`export LC_ALL="en_US.UTF-8"`
`export LANGUAGE="en_US.UTF-8"`
#### 用 Dockerfile 來封裝 python flask
1. 新增目錄 `mkdir flask-hello-world`
2. 跳轉到目錄裡面，新增 Dockerfile `cd flask-hello-world`
3. 新增 Dockerfile `vim Dockerfile`
```
FROM python:3.6
LABEL maintainer="Fishboneapps<vincent@fishboneapps.com>"
RUN pip install flask
COPY app.py /app/
WORKDIR /app
EXPOSE 5000
CMD ["python", "app.py"]
```
4. 將 Dockerfile 製作成 Image
`docker build -t fishboneapps/flask-hello-world .`
5. 運行製作好的 Image
`docker run -d fishboneapps/flask-hello-world`
#### Dockerfile 總結
1. Dockerfile 編寫分三步驟
    - 第一步（環境）：引入庫，安裝套件，環境的搭建
    - 第二步（代碼）：通過 COPY 或是 ADD 添加到 Image 裡面
    - 第三步（CMD）：運行程序
### 容器的操作
#### Docker Exec 命令
1. docker exec -it [容器id] [執行命令]
`docker exec -it 1f7e35f8a8b6 /bin/bash`
2. 檢查 python 的服務
`ps -ef | grep python`
3. 改成運行 python，就會看到直接進去 python 的 shell 裡面
`docker exec -it 1f7e35f8a8b6 python`
4. 可以在 shell 裡面測試運行 Hello Docker，然後退出
```
print ("hello docker")
exit()
```
5. 打印出容器的 ip 地址
`docker exec -it 1f7e35f8a8b6 ip a`
6. 停止容器 docker stop [容器id]
`docker stop 1f7e35f8a8b6`
7. 刪除所有停止的容器
`docker rm $(docker ps -aq)`
8. 建立容器並指定名稱，如果不指定名稱的話，Docker 會分配一個名字
`docker run -d --name=demo fishboneapps/flask-hello-world`
9. 停止容器也可以用 name，name 是唯一的
`docker stop demo`
10. 開始容器一樣也可以用 name
`docker start demo`
11. 顯示容器的詳細資訊
`docker inspect demo`
12. 顯示容器的 logs
`docker logs demo`
13. [Docker container 命令文檔](https://docs.docker.com/engine/reference/commandline/container/)
### Dockerfile 實戰(2)
#### 壓力測試工具 - Stress
1. 開啟一個 ubuntu 容器
`docker run -it ubuntu:18.04`
2. 安裝 stress
`sudo apt-get update && apt-get install -y stress`
3. 找尋 stress 路徑
`which stress`
4. 查看 stress 命令 `stress --help`
```
 -v, --verbose      be verbose // 顯示更多資料
 -m, --vm N         spawn N workers spinning on malloc()/free() // 生成 worker
     --vm-bytes B   malloc B bytes per vm worker (default is 256MB) // 分配記憶體給 worker，默認 256MB
     --vm-stride B  touch a byte every B bytes (default is 4096)
     --vm-hang N    sleep N secs before free (default none, 0 is inf)
     --vm-keep      redirty memory instead of freeing and reallocating
```
5. 測試 stress
`stress --vm 1 --verbose`
6. 分配 500000M 的記憶體給 Worker 會無法分配，因為 Host 機器沒有那麼多記憶體
`stress --vm 1 --vm-bytes 500000M --verbose`
7. 將以上步驟打包成 docker image，新增 Dockerfile
```
FROM ubuntu:18.04
RUN apt-get update && apt-get install -y stress
ENTRYPOINT ['/usr/bin/stress']
CMD []
```
8. 製作成 image
`docker build -t fishboneapps/ubuntu-stress .`
9. ENTRYPOINT + CMD[] 的形式，可以在啟動容器時，指定命令參數
`docker run -it fishboneapps/ubuntu-stress --vm 1 --verbose`
### 容器資源限制
1. 使用剛剛的 ubuntu-stress，只分配 200M 的 memory 給容器，容器會退出，因為記憶體不足
`docker run --memory=200M fishboneapps/ubuntu-stress --vm 1 --verbose --vm-bytes 500M`
2. --cpu-shares 命令，是指定容器的相對權重，開啟 3 個 terminal 進行測試
    - 第一個 termianl 執行 `docker run --cpu-shares=10 --name=test1 fishboneapps/ubuntu-stress --cpu 1`
    - 第二個 terminal 執行 `docker run --cpu-shares=5 --name=test2 fishboneapps/ubuntu-stress --cpu 1`
    - 第三個 terminal 執行 `top` 進行監控
3. 監控後會發現，cpu 的占比，test1 容器的 cpu 占比會是 test2 容器的 2 倍，總和 cpu 的使用量約為 100%







