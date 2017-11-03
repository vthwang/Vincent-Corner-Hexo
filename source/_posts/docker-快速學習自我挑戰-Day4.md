---
title: docker 快速學習自我挑戰 Day4
thumbnail:
  - /images/learning/docker/dockerday4.png
date: 2017-07-28 15:32:17
categories: 學習歷程
tags: Docker
---
<img src="/images/learning/docker/dockerday4.png">

***
### Container 生命週期和持久性數據：Volumes, Volumes, Volumes
#### Container 生命週期和持久性數據
##### 學習重點
1. 定義持久性數據的問題
2. Container 的關鍵觀念：immutable，ephemeral
3. 學習使用 Data Volumes
4. 學習使用 Bind Mounts
5. 作業
##### 觀念
1. Container **通常**是 immutable 而且 ephemeral
2. 「immutable infrastructure」：只重新部署 container，從來都不改變
3. 這些都是理想的情境，但是 databases 或 unique data 呢？
4. Docker 給我們一些特色來確保這些「separation of concerns」
5. 這些被稱為「persistent data」
6. 兩種方法：Volumes 和 Bind Mounts
7. Volumes：製作一個特別的地點在 container UFS(Unit File System) 之外
8. Bind Mounts：連結 container 路徑到 host 路徑
#### 持久性數據：Data Volumes
1. Dockerfile 裡面的 `VOLUME` 命令
2. `docker volume prune` 可以清除未使用的 volume
3. `docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=True mysql` 使用 mysql 的 image 開啟一個 container
4. `docker container inspect mysql` 查看 mysql 狀態，`Mounts` 可以看到路徑
5. `docker volume inspect {Volume Name}` 可以看到 Mountpoint 路徑
6. `docker container rm {container name}` 將 container 都刪除之後，使用 `docker volume ls` 觀察，會發現 Volume 都還會在
7. `docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=True -v mysql-db:/var/lib/mysql mysql` `-v` 的指令在這邊表示外接 volume，volume 的名稱為 mysql-db
8. `docker volume create` 必須要在 `docker container run` 之前執行，這樣才能選擇自訂的 drives 和 labels
#### 持久性數據：Bind Mounting
1. Map host 檔案或目錄到 container 的檔案或目錄
2. 基本上只有兩個位址會指定到相同的檔案
3. 省略 UFS 和 host 檔案覆寫任何 container 裡的東西
4. 不能在 Dockerfile 使用，必須在 `container run` 的時候使用
5. `... run -v /Users/vincent/stuff:/path/container` (Mac/Linux)
6. `... run -v //c/Users/vincent/stuff:/path/container` (Windows)
7. `docker container run -d --name nginx -p 80:80 -v $(pwd):/usr/share/nginx/html nginx` 新增一個 container 並指定 volume 到現在的路徑 $(pwd)
8. `docker container run -d --name nginx2 -p 8080:80 nginx` 再新增一個 container 做比較
9. `docker container exec -it nginx bash` 用 bash 連進去 nginx
10. `touch testme.txt` 在本來的目錄新增檔案，最後檔案會出現在 container 裡面，因為目錄是共用的
#### 作業：Database 與命名好的 Volume 一起升級
1. 讓 database 跟 container 一起升級
2. 創建一個 **postgres** container 並將 volume 命名為 psql-data，且使用版本 **9.6.1**
3. 使用 Docker Hub 學習 **VOLUME** 必要路徑和版本，然後運行它
4. 檢查 logs 並停止 container
5. 再創建一個 **postgres** container 並使用同個 volume 名稱，且使用版本 **9.6.2**
6. 透過檢查 logs 來驗證
7. (這些只在 patch 版本能運作，大部分 SQL 資料庫需要手動設定指令來升級資料庫到主要/次要版本，換言之，這是資料庫的限制，而非 container 的限制)
#### 答案：Database 與命名好的 Volume 一起升級
1. `docker container run -d --name psql -v psql:/var/lib/postgresql/data postgres:9.6.1`
2. `docker container logs -f psql` `-f` 代表持續 follow
3. `docker container stop psql`
4. `docker container run -d --name psql2 -v psql:/var/lib/postgresql/data postgres:9.6.2`
5. `docker container logs psql2`
#### 作業：編輯與 Bind Mounts 一起運行的 container 的程式碼
1. 使用 Jekyll 「靜態網頁生成器」來啟動本地端的 web server
2. 不一定要成為 web 開發者：這是一個橋接在本地檔案存取和運行在 container 的 apps 間的 gap 的範例
3. 來源程式碼在 **bindmount-sample-1** 的課程 repo 裡面
4. 我們會用 host 上的原生工具當作編輯器來編輯檔案
5. Container 偵測到 host 端檔案改變，會到 web server 更新
6. 使用 `docker run -p 80:4000 -v $(pwd):/site bretfisher/jekyll-serve` 開啟 container
7. 重整瀏覽器來觀察變化
8. 修改 **_posts\\** 且重整瀏覽器來觀察變化
#### 答案：編輯與 Bind Mounts 一起運行的 container 的程式碼
1. 使用 `docker run -p 80:4000 -v $(pwd):/site bretfisher/jekyll-serve` 開啟 container
2. 直接編輯目錄底下的 **_posts\\** 並重整瀏覽器，網站就會直接修改
3. [Jekyll 靜態網頁生成器](https://jekyllrb.com/)