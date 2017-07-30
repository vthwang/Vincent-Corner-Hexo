---
title: docker 快速學習自我挑戰 Day6
thumbnail:
  - /blogs/images/learning/docker/dockerday6.png
date: 2017-07-30 04:50:58
categories: 學習歷程
tags: Docker
---
<img src="/blogs/images/learning/docker/dockerday6.png">

***
### Docker 服務和 Swarm 的威力： Build-In Orchestration
#### Swarm 模式：Build-In Orchestration
##### 到處都有 container = 新問題
1. 我們如何自動化 container 生命週期？
2. 我們如何簡單的 scale out/in/up/down？
3. 我們如何確保我們的 container 在失敗的情況下會自動重建？
4. 我們如何取代 container 且沒有任何停機時間(藍色/綠色部署)？
5. 我們如何控制/追蹤哪裡的 container 啟動了？
6. 我們如何創建 cross-node 虛擬網路？
7. 我們如何確保只有受信任的伺服器可以運行我們的 container？
8. 我們如何儲存 secrets、keys、passwords 且將它們放到正確的 container (或是只有那個 container)？
##### Swarm 模式：Build-In Orchestration
1. Swarm 模式是建立在 Docker 裡面的叢集解決方案
2. 跟早於 1.12 版本的 Swarm "classic" 沒有關係
3. 被 SwarmKit toolkit 新增到 1.12 (2016 年夏天)
4. 被 Stacks and Secrets 做改善後新增到 1.13 (2017 年 1 月)
5. 預設並沒有被啟動，一旦啟動會有以下新指令
    - docker swarm
    - docker node
    - docker service
    - docker stack
    - docker secret
6. Manager Node
    - API：從客戶端接受指令並創建服務 object
    - Orchestrator：協調服務 object 和創建任務間的 loop
    - Allocator：分配 IP 給任務
    - Scheduler：分配 node 給任務
    - Dispatcher：在 Worker Node 報到
7. Worker Node
    - Worker：連接 dispatcher 來檢查被分配的任務
    - Executor：執行被分派到 Worker Node 的任務
#### 創建第一個服務且在本地端擴展它
1. `docker info` 可以檢查 swarm 是否開啟
2. `docker swarm init --advertise-addr <ip>` 啟用 swarm
3. docker swarm init：剛剛發生什麼事情了？
    - 眾多 PKI 和安全自動化
        - 用於 swarm 的 Root 登入認證被建立
        - 用於第一次的 Manager Node 認證被發佈
        - Join tokens 被創建
    - Raft 資料庫被建立，並被用來儲存 root CA、config 和 secrets
        - 在硬碟上預設被加密 (1.13+)
        - 不需要為了額外的 key/value 系統來保有 orchestration/secrets
        - 使用 mutual TLS 的 Managers 中的 Replicates logs 在「控制面板」中
4. `docker service create alpine ping 8.8.8.8`
5. `docker service update eloquent_ride --replicas 3` 升級 replicas
6. `docker container rm -f <container name>` 刪除其中一個 container，他也會自動再產生，可以用 `docker service ps <service name>` 檢查紀錄
#### 創建一個 3-Node Swarm 叢集
##### 創建一個 3-Node Swarm：Host 選項
1. [play-with-docker.com](http://play-with-docker.com)
    - 只需要瀏覽器，但是在四小時後會重置
2. Docker-machine + VirtualBox
    - 本地端可以免費執行和運作，但是需要一台大於 8GB 記憶體的機器
3. Digital Ocean + Docker install
    - 大部分很像產品化的設置，但是在學習時要花費 $5-10/node/mouth
4. 註冊自己的
    - docker-machine 可以用在 Amazon、Azure、DO、Google...等等的配置機器
    - 使用 get.docker.com 到處安裝 docker
##### 開始建立
1. [安裝 Docker-machine](https://github.com/docker/machine/releases/)
2. [下載指令稿](https://get.docker.com/)
3. `docker swarm init --advertise-addr <ip>` 啟動 swarm
4. 啟動後會產生 join 的指令，把指令貼在其他兩台上面
5. `docker swarm join-token manager` 取得 manager 的 token
#### 使用 Overlay Network 進行擴展
1. 當創建網路的時候就選擇 `--driver overlay`
2. 為了在單一 Swarm 裡面的 container-to-container traffic
3. 在網路建立的時候，選擇性使用的 IPSec (AES) 加密法
4. `docker network create --driver overlay mydrupal` 建立一個新網路
5. `docker service create --name psql --network mydrupal -e POSTGRES_PASSWORD=mypass postgres`
6. `docker service create --name drupal --network mydrupal -p 80:80 drupal`
7. 在瀏覽器隨便輸入其中一個 node 的 ip 都可以執行
#### 使用 Routing Mesh 進行擴展
1. 為了將服務分配到適當的任務的 Routes ingress(incoming) 封包
2. 在 Swarm 裡面 span 所有 nodes
3. 使用 Linux 核心裡面的 IPVS
4. 在任務間做 Swarm Services 的負載平衡
5. 兩個方法讓這樣的模式可以執行：
    - 在 Overlay network 裡面運行 container-to-container (使用 VIP)
    - 外部 traffic 進入到 published ports (所有的 nodes listen)
6. `docker service create --name search --replicas 3 -p 9200:9200 elasticsearch:2`
7. `curl localhost:9200` 檢查狀態
8. 這是無狀態的負載平衡
9. 這個負載平衡(LB)位在 OSI 第三層 (TCP)，不是第四層 (DNS)
10. 以上兩種限制都可以透過以下來克服：
    - Nginx 或 HAProxy LB proxy
    - Docker Enterprise Edition，它內建 L4 web proxy
#### 作業：建立一個 Multi-Service Multi-Node Web App
1. 使用 Docker 分散式投票 App
2. 使用課程倉庫裡面的 [**swarm-app-1**](https://github.com/BretFisher/udemy-docker-mastery/tree/master/swarm-app-1) 目錄來完成需求
3. 需要 1 volumes, 2 networks, 5 services
4. 建立需要的 commands，讓服務跑起來並測試 App
5. 所有的東西都使用 Docker Hub images，所以在 Swarm 上面不需要任何 data
6. 像很多電腦的東西，這是一半藝術一半科學
#### 答案：建立一個 Multi-Service Multi-Node Web App
1. `docker network create -d overlay backend`
2. `docker network create -d overlay frontend`
3. Vote App：`docker service create --name vote -p 80:80 --network frontend --replicas 2 dockersamples/examplevotingapp_vote:before`
4. Redis：`docker service create --name redis --network frontend redis:3.2`
5. Worker：`docker service create --name worker --network frontend --network backend dockersamples/examplevotingapp_worker`
6. Postgres：`docker service create --name db --network backend --mount type=volume,source=db-data,target=/var/lib/postgresql/data postgres:9.4`
7. Result：`docker service create --name result --network backend -p 5001:80 dockersamples/examplevotingapp_result:before`