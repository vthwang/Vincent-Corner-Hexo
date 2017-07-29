---
title: docker 快速學習自我挑戰 Day5
thumbnail:
  - /blogs/images/learning/docker/dockerday5.jpg
date: 2017-07-29 12:37:49
categories: 學習歷程
tags: Docker
---
<img src="/blogs/images/learning/docker/dockerday5.jpg">

***
### 讓 Docker Compose 更簡單：Multi-Container 工具
#### Docker Compose 和 The docker-compose.yml
##### Docker Compose
1. 為什麼：搞清楚 container 之間的關係
2. 為什麼：將 Docker container 的運行設定存成易讀取的檔案
3. 為什麼：一線開發者環境啟動
4. 可以分成兩個相關的事情
    - YAML 格式描述我們的解決方案選項：containers、networks、volumes
    - CLI 工具 **docker-compose** 被用在開發/測試自動化且使用 YAML 檔案
##### docker-compose.yml
1. Compose YAML 格式有自己的版本：1、2、2.1、3、3.1
2. YAML 檔案可以被用於本地 docker 自動化或...的 **docker-compose** 命令
3. **docker** 已經直接被產品化，叫做 Swarm (從 v.1.13 開始)
4. `docker-compose --help`
5. **docker-compose.yml** 是預設名稱，但是`docker-compose -f`可以任何使用喜歡的名稱
#### 測試基本 Compose 命令
1. Docker 的 CLI 工具有 Windows/Mac 版本，但是 Linux 需要分開下載
2. 不是一個產品化等級的工具，但是對在本地端開發和測試是理想的
3. 最常使用的兩個命令是
    - `docker-compose up` # 設定 volumes/networks 和開啟所有的 containers
    - `docker-compose down` # 停止所有的 containers 和移除 cont/vol/net
4. 如果你的所有專案都有 **Dockerfile** 和 **docker-compose.yml**，那「新的開發者」應該要
    - `git clone github.com/some/software`
    - `docker-compose up`
5. 進入超級管理員模式 `sudo -i`
6. 安裝 docker-compose [最新版本](https://github.com/docker/compose/releases) ``curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose``
7. 



