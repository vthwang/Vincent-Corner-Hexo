---
title: docker 快速學習自我挑戰 Day2
thumbnail:
  - /images/learning/docker/dockerday2.png
date: 2017-07-24 15:09:19
categories: 學習歷程
tags: Docker
---
<img src="/images/learning/docker/dockerday2.png">

***
### 安裝與版本
#### Windows Container：Docker 不再只能在 Linux 上面執行
1. 目前 17 版已經可以在 windows 上執行 docker，但有些功能不能使用，包括 Swarm Overlay、Secret...等等
2. 可以參考以下影片
    - [Windows Containers and Docker: 101](https://www.youtube.com/watch?v=066-9yw8-7c)
    - [Beyond \ - the path to Windows and Linux parity in Docker](https://www.youtube.com/watch?v=4ZY_4OeyJsw)
    - [Docker + Microsoft - Investing in the Future of your Applications](https://www.youtube.com/watch?v=QASAqcuuzgI)
#### 作業 - 管理多個 container
1. Docker 小幫手 (1) [官方文件](https://docs.docker.com/) (2) `--help`
2. 運行 nginx、MySQL、httpd(apache) server
3. 運行以上軟體，並使用 `--detached` (或 `-d`)，並用 `--name` 命名
4. nginx 要使用 80:80，httpd 用 8080:80，MySQL 用 3306:3306
5. 當執行 MySQL，使用 --environment (或 `-e`) 將 `MYSQL_RANDOM_ROOT_PASSWORD=yes` 參數傳進去 container
6. 在 MySQL 使用 `docker container logs` 來找到創建時所產生的隨機密碼
7. 使用 `docker container stop` 和 `docker container rm` 將全部的資料清除
8. 在清除之前，使用 `docker container ls` 確定資料的狀態是否正確
9. 可以使用 `curl localhost` 會出現網頁 index 的檔案
#### Container 裡面發生了什麼事情呢？CLI 進程監控
1. `docker container top` 某一個 container 的進程清單
2. `docker container inspect` 某一個 container 的設定細節
3. `docker container stats` 所有 container 的效能統計
#### 在 Container 裡面取得 Shell：不需要使用 SSH
1. `docker container run -it` 以交互方式開啟新的 container
2. `docker container exec -it` 在已存在的 container 執行額外的 command
3. 在眾多 container 裡面有不同的 Linux 發行版本
4. `docker container run -it --name proxy nginx bash` 進去 container 裡面
5. `docker container run -it --name ubuntu ubuntu` 直接執行，不需加 bash 結果會一樣，因為預設就是 bash
6. `docker container start -ai ubuntu` 如果要重新開機，可以使用這個指令
7. Alpine Linux：一個小型且以安全為目的的 Linux 分支 `docker pull alpine` 下載最新的 alpine
8. `docker container run -it alpine sh` 因為沒有 bash，所以用 sh
9. [套件管理基本](https://www.digitalocean.com/community/tutorials/package-management-basics-apt-yum-dnf-pkg)
#### Docker 網路：眾多 Container 裡面的私有和公有網路的溝通觀念
1. 觀念
    - `docker container run -p` p 就是你機器上的 port
    - 對於本地端的開發/測試，網路通常『只是堪用』
    - `docker container port <container>` 這個指令可以快速輸出哪一個 port 為這個 container 開啟
    - 學習 Docker 網路、虛擬網路和封包如何傳遞
    - 了解網路封包如何在 Docker 之間移動
2. 預設 Docker 網路
    - 每一個 container 都會連接到虛擬網路 「橋(bridge)」
    - 每一個虛擬網路路由都會透過 NAT 防火牆轉址到 host IP
    - 在虛擬網路上所有的 container 都可以互相溝通，而不需要 `-p`
    - 最好的練習就是對個別的 app 新增虛擬網路
        * MySQL 和 php/apache 用「my\_web_app」網路
        * Mongo 和 nodejs 用 「my_api」網路
    - 「含電池，但可拆卸 (battery included, But Removable)」
        * 在多數情況下，預設會運行的很好，但很容易換掉客製化的 ports
    - 新建虛擬網路
    - 連結 container 們到大於1(或者沒有)的虛擬網路
    - 省略虛擬網路且使用 host IP (--net=host)
    - 使用不同的 Docker 網路驅動來取得新的能力
#### 錯誤修改：Nginx 官方 image 移除 Ping 功能
1. 因為最新 2017 官方修改 ping 功能，所以把 `docker container run <stuff> nginx`，要把 `nginx` 取代為 `nginx:alpine`，這樣就可以繼續使用 ping 的 command
#### Docker 網路：虛擬網路的 CLI 管理
1. `docker network ls` 顯示所有網路
2. `docker network inspect` 檢查特定網路
3. `docker network create --driver` 創建一個網路
4. `docker network connect` 連結一個網路到 container
5. `docker network disconnect` 從 container 移除一個網路
6. 在同個 Docker 網路創建前端/後端應用，這樣他們之間的溝通就不會留給 host
7. 所有的在外部暴露的 port 預設會關閉，需要手動使用 `-p` 打開，這樣才有更好的預設安全
8. 接下來後面要提到的 Swarm 和 Overlay 網路更好
#### Docker 網路：DNS 和 container 如何找到彼此
1. 了解 DNS 是如何成為容易交互溝通的關鍵
2. 觀察客製化的網路預設是如何運作的
3. 學習如何使用 `--link` 來讓 DNS 在預設橋接網路生效
4. 請遺忘 IP：固定 ip 和使用 ip 來讓 container 之間溝通是一種反面模式，盡可能地避免這樣的事情發生
5. Docker DNS：Docker daemon 有內建的 DNS server，而Container 會預設使用它
6. DNS 預設名稱：Docker 預設 hostname 到 container 的名字，但是還是可以設定 aliases
7. 如果使用客製網路，友善的 DNS 名稱是內建的
8. 這些使用 Docker Compose 都會更簡單
#### 作業：使用 container 做 CLI testing
1. 知道如何使用 -it 在 container 裡面使用 shell
2. 了解基本的 linux distribution，像是 Ubuntu 和 CentOS
3. 了解如何執行 container
4. 作業
    - 使用不同的 distro container 來檢查 curl cli 工具版本
    - 使用兩個不同的終端視窗來開啟 bash，使用 -it 來啟動 **centos:7** 和 **ubuntu:14.04**
    - 學習 `docker container --rm` 選項，這樣可以 save cleanup
    - 確定最新版本的 curl 有安裝在相對應的 distro
        * ubuntu: `apt-get update && apt-get install curl`
        * centos: `yum update curl`
    - 檢查 `curl --version`
#### 作業：DNS Round Robin 測試
1. 了解如何使用 `-it` 在 container 裡面使用 shell
2. 了解基本的 linux distribution，像是 Ubuntu 和 CentOS
3. 了解如何執行 container
4. 了解 DNS 紀錄的基礎
5. 從 Docker Engine 1.11 之後，我們可以創建很多 container 到一個網路且傳遞到相關的 DNS 位址
6. 創建一個新的虛擬網路(預設 bridge driver)
7. 從 `elasticsearch:2` 的 image 創建兩個 container
8. 搜尋和使用 `--net-alias search`，當我們創建 container 的時候，同時給他們額外的 DNS name 去響應
9. 執行 `alpine nslookup search` 並加上 `--net` 來觀察兩個使用相同 DNS 名稱的 container 列表
10. 多次執行 `centos curl -s search:9200` 並加上 `--net`，直到觀察到**名稱**欄位出現
#### 完成作業
1. 執行兩次 `docker container run -d --net dude --net-alias search elasticsearch:2`，開啟兩個 container
2. `docker container run --rm --net dude alpine nslookup search` 觀察兩個使用相同 DNS 名稱的 container 列表
3. `docker container run --rm --net dude centos curl -s search:9200`