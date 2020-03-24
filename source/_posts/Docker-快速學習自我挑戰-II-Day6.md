---
title: Docker 快速學習自我挑戰 II Day6
thumbnail:
  - /images/learning/docker-2/DockerDay06.png
date: 2020-03-02 10:20:53
categories: Study Note
tags: Docker
---
<img src="/images/learning/docker-2/DockerDay06.png">

***
### 容器編排 Swarm
1. 到處使用 Container 很麻煩，為了解決這些問題，Docker Swarm 就出現了
    - 如何管理這麼多容器？
    - 如何橫向擴展？
    - 如果容器 down 了，如何自動恢復？
    - 如何更新容器不影響業務？
    - 如何監控和追蹤這些容器？
    - 如何調度容器的創建？
    - 如何保護隱私數據？
2. Swarm 是集群，有集群就有節點，有節點就有角色，Swarm 總共有兩個角色，一個叫做 Manager，另一個叫做 Worker，Manager 就是大腦的角色，為了避免故障，Manager 至少要有兩個節點，但是多節點就會涉及到同步的問題，如何把 Manager A 的資料同步到 Manager B？這裡面就會用到內置的分佈式儲存的數據庫，數據是透過 Raft 協議去做的同步，Raft 能保證 Manager 之間的資料是對稱的，而 Worker 就是工作的節點，而這些工作的節點數據也是要同步的，它們會透過 Gossip network 來進行同步，這就是 Docker Swarm 的基礎架構

<img src="/images/learning/docker-2/DockerDay06-Image01.png">

3. Services 和 Replicas，這邊的 Service 和 Docker Compose 的 Service 基本是一樣的，一個 Service 就代表一個 Container，在 Replicas 的模式下，要橫向去做擴展，一個 Replica 就是一個 Container，如下圖，我們要做 3 個 Replicas，它就會產生 3 個 Container，調度系統就會把 Container 調度到不同的 node 上面，透過一個 Swarm Manager 的節點去部署 Service 的時候，我們是不知道這些 Service 會運行在哪些 Swarm Node 上面的，這會透過 Swarm Scheduler 調度演算法去計算的，它會去看哪些 Node 負載比較輕，就會把 Container 調度到上面

<img src="/images/learning/docker-2/DockerDay06-Image02.png">

4. Swarm 創建 Service 調度的過程，我們會在 Swarm Manager 做一些調度的決策，最後 Service 會部署在某個 Node 上面

<img src="/images/learning/docker-2/DockerDay06-Image03.png">

### 創建一個 3 個 Nodes 的 Swarm 集群
1. 先使用 Vagrant 創建 3 台機器
2. 連進去第一台機器，並初始化 Docker Swarm，它就會產生讓 Worker 加入的指令
`docker swarm init --advertise-addr=192.168.205.13`
3. 在每個 worker 上執行初始化所產生的指令，就可以加入 Docker Swarm
`docker swarm join --token SWMTKN-1-0beqcld9mv5m3w4fg1hdg3kcwqankezakxcj3k4ml0pbwq7pzj-f19znzunp0rc7kjiqfxuy4g4g 192.168.205.13:2377`
4. 在 manager 上執行 `docker node ls` 查看 Node 狀態，就會看到 1 個 manager，兩個 workers，Docker Swarm 就部署完畢了
### Service 的創建維護和水平擴展
1. 在 manager 上創建一個 Service
`docker service create --name demo busybox sh -c "while true;do sleep 3600;done"`
2. 使用 `docker service ls` 查看 Service 狀態
3. 使用 `docker service ps demo`  查看 Service 運行位置
4. 使用 `docker ps` 查看 container 會發現名稱是 demo 加上一堆亂數，因為 demo 是 Service 的名稱，不是 Container 的名稱
5. 水平擴展 demo
`docker service scale demo=5`
6. `docker service ps demo` 可以顯示所有 Container 的狀態，去個別的 Node 使用 `docker ps` 可以查看 Container 是否運行在對應的機器上
7. 在 worker1 上刪除一個容器 `docker rm -f 16be3f59200c`，並在 manager 上執行 `docker service ps` 會發現 Replicas 剩下 4 個，過一下子，再執行 `docker service ps` 又會變回 5 個了
8. 使用 `docker service ps demo` 就會看到剛剛在 worker1 刪除的 Container shutdown 了，它又在 worker2 又啟動了一個，如果 Swarm 發現有 Container 被停止了，就會立刻在任意一個節點上啟動一個
9. 使用 `docker service rm demo` 可以刪除 Service，如果在節點上執行 `docker ps` 看到還有 Container，那是因為後台操作比較複雜，Swarm 需要看 Container 分佈在哪些 Node 上面，所以，只要稍微等一下，就會全部停止了
### 在 Swarm 集群通過 Service 部署 WordPress
1. 為了要讓 Swarm 裡面的 Container 互相溝通，需要在 manager 先新增網路
`docker network create -d overlay demo`
2. 在 manager 查看網路 `docker network ls` 會看到剛剛新增的 demo，但是去 worker1 和 worker2 會找不到這個 demo
3. 先不管網路，先新增 mysql Service
`docker service create --name mysql --env MYSQL_ROOT_PASSWORD=root --env MYSQL_DATABASE=wordpress --network demo --mount type=volume,source=mysql-data,destination=/var/lib/mysql mysql:5.7`
4. 接下來，在新增 wordpress Service
`docker service create --name wordpress -p 80:80 --env WORDPRESS_DB_PASSWORD=root --env WORDPRESS_DB_HOST=mysql --network demo wordpress`
5. `docker service ps wordpress` 查看 WordPress 服務運行在哪個節點，在瀏覽器用該節點 ip 進入 WordPress 網站頁面，並進行安裝，安裝完成就確定 MySQL 和 WordPress 這兩個 Service 是可以互享訪問的
6. 我們可以知道 WordPress Container 是在 worker2，使用 worker2 的 ip 可以訪問網站，但是使用 manager 和 worker1 的 ip 一樣也可以訪問網站，這個原因在下個章節會說明
7. 前面提到網路的問題，在新增完 Service 之後，我們可以看到 1 個 Service 在 manager，一個在 worker1，使用 `docker network ls` 就會看到前面新增的 demo 網路，而在沒有 Service 的 worker2 則看不到這個網路，也就是說，Swarm 在 worker1 新增 Service 的同時，也會讓 Overlay 的網路進行同步，前面提到多 Container 通信是使用 etcd，而 Docker Swarm 是不需要使用第三方的服務，本身底層的機制就會同步網路的創建
### 集群服務間通訊的 Routing Mesh
1. Docker Swarm 的 Service 之間的溝通是透過 DNS 服務來實現，Swarm 本身有 DNS 服務發現的功能，在新增 Service 的同時， Swarm 就會把 Service 的紀錄新增到 DNS 紀錄裡，我們透過 DNS 紀錄就可以知道 Service 的 ip 地址，但是 Service 的 ip 地址並不是 Container 的 ip 地址，它會有一個 vip(虛擬 ip) 地址(如果 Service 有進行 scale 的情況下， container 不一定會在哪個節點上面，某個 Container shutdown 了，Swarm 會自動在其它節點新增 Container，這時候 Container 的 ip 地址都會改變，所以如果根據 Container 的實際地址去紀錄的話，這樣是很不穩定的)，Service 分配到的 vip 地址是不會變的，但是這個不變的 ip 後面會指向的真實 ip，它會在 Service 上創建一個 Container，它是透過 LVS 去實現的

<img src="/images/learning/docker-2/DockerDay06-Image04.png">

2. 創建一個 whoami 的 Service
`docker service create --name whoami -p 8000:8000 --network demo -d jwilder/whoami`
3. 查看 Service 在哪個 Node 上面
`docker service ps whoami`
4. 在該 Node 執行 `curl 127.0.0.1:8000` 就會回傳 Container id
5. 再創建一個 busybox 的 Service
`docker service create --name client -d --network demo busybox:1.28 sh -c "while true; do sleep 3600; done"`
6. 查看 Service 在哪個 Node 上面
`docker service ps client`
7. 在該 Node 上執行進入 Container
`docker exec -it client.1.kjw6og8khm6g8q2s8nhznrkg1 sh`
8. 我們去 ping whoami 這個 Service `ping whoami`，會發現是可以通的，但是會發現它 ping 的是 10.0.1.24，並不是 Container 的實際 ip
9. 接下來，我們把 whoami 進行擴展並查看 Service 運行在哪個 Node 上面
`docker service scale whoami=2`
`docker service ps whoami`
10. 在該 Node 查看 Container `docker ps`，就會發現新增的 whoami 運行在該 Node 上面
11. 我們再次在 busybox 的 Container 上 ping whoami，發現還是可以通，而且它的 ip 還是 10.0.1.24，現在有兩個 whoami，但是只有一個名稱，到底是 ping 了哪個 Container 呢？現在的 10.0.1.24 其實不是兩個 Container 中的其中一個地址，而是一個 vip 地址
12. 我們可以有 whoami Container Node 查詢 ip，會發現 10.0.1.24 不存在任何這兩個 Container 中
`docker exec whoami.1.miy2t0q5khq02gqlg1txk1d4v ip a`
`docker exec whoami.2.am4jalucvzl0tazkr0qnnxdho ip a`
13. 再次在 busybox 查詢 `nslookup whoami`，會發現回傳的地址是 10.0.1.24，使用 `nslookup tasks.whoami`，就會回傳 Container 的真實 ip
```
/ # nslookup tasks.whoami
Server:    127.0.0.11
Address 1: 127.0.0.11

Name:      tasks.whoami
Address 1: 10.0.1.25 whoami.1.miy2t0q5khq02gqlg1txk1d4v.demo
Address 2: 10.0.1.30 whoami.2.am4jalucvzl0tazkr0qnnxdho.demo
```
14. 我們可以嘗試把 whoami Service 橫向擴展，`docker service scale whoami=3`，在 Busybox Node 使用 `nslookup tasks.whoami` 就會返回 3 筆 DNS 紀錄
15. 接下來繼續在 busybox 裡面操作 `wget whoami:8000`，並讀取 `more index.html`，查看 Container id，然後刪除 `rm -rf index.html`，再次操作 `wget whoami:8000`，並讀取 `more index.html`，查看 Container id，會發現 Container id 改變了，也就是說，我們每次讀取的 Container 是不同的，這些負載平衡的操作，都是透過 LVS 實現的
16. Routing Mesh 的兩種體現
    - <span style="color:red">**Internal**</span> - Container 和 Container 之間的訪問透過 Overlay 網路(通過 vip 虛擬 ip)，Container 間透過 Service name 就可以訪問，如果 Service scale 的話，通過 vip 訪問會自動做負載平衡
    - <span style="color:red">**Ingress**</span> - 如果 Service 有綁定接口，則此服務可以通過任意 Swarm 節點的相應接口訪問，下章節會更詳細的講
17. Internal Load Balacing 會自動透過 VIP 做負載平衡到每一個 Service 節點上

<img src="/images/learning/docker-2/DockerDay06-Image05.png">

18. 我們在 Client Container 訪問別的 Service 的時候，會先查詢 DNS，把 Service Name 解析成具體的 vip，然後會透過 Iptables 和 IPVS 來負載平衡到各個 Service 節點上

<img src="/images/learning/docker-2/DockerDay06-Image06.png">

### Docker Stack 部署 WordPress
1. 查看 [Docker Compose Version 3 Reference](https://docs.docker.com/compose/compose-file/#deploy) 的 deploy 的配置命令
    - [ENDPOINT_MODE](https://docs.docker.com/compose/compose-file/#endpoint_mode) - 網路模式，默認為 `vip`，還有一種 `dnsrr`，全稱為 DNS round-robin，負載平衡用輪流的方式來進行
    - [LABELS](https://docs.docker.com/compose/compose-file/#labels-1) - 標籤
    - [MODE](https://docs.docker.com/compose/compose-file/#mode) - 模式，默認為 `replicated`，可以生成很多 Container，另一種選項為 `global`，只會有一個 container
    - [PLACEMENT](https://docs.docker.com/compose/compose-file/#placement) - 可以放入一些限制和偏好設置，例如：constraints 若設置為 `node.role == manager`，則該 Service 只會產生在 manager 節點
    - [REPLICAS](https://docs.docker.com/compose/compose-file/#replicas) - 複製個體，可以設定有幾個複製體
    - [RESOURCES](https://docs.docker.com/compose/compose-file/#resources) - 資源限制，可以優先分配 cpu 和 memory 給特定 Service
    - [RESTART_POLICY](https://docs.docker.com/compose/compose-file/#restart_policy) - 重啟參數，可以設置一些延遲或是最大重啟次數
    - [UPDATE_CONFIG](https://docs.docker.com/compose/compose-file/#update_config) - 更新的時候，遵循的原則，假設我設定 `parallelism: 2`，那麼更新一次可以更新兩個 Replicas，設置 `delay: 10s`，每次更新的延遲就為 10 秒，也就是說要等第一個更新完成後 10 秒才能更第二個
2. 前面用過 Docker Compose 在本地部署 WordPress，現在要把 WordPress 部署到 Docker Swarm 裡面，將之前的 docker-compose.yml 檔案進行修改，首先要修改網路為 Overlay，然後 Service 部分加上一些 deploy 的參數
```
version: '3'

services:

  web:
    image: wordpress
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_PASSWORD: root
    networks:
      - my-network
    depends_on:
      - mysql
    deploy:
      mode: replicated
      replicas: 3
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
      update_config:
        parallelism: 1
        delay: 10s

  mysql:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: wordpress
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - my-network
    deploy:
      mode: global
      placement:
        constraints:
          - node.role == manager

volumes:
  mysql-data:

networks:
  my-network:
    driver: overlay
```
3. 利用 docker-compose.yml 啟動 Stack
`docker stack deploy wordpress --compose-file=docker-compose.yml`
4. 可以利用 `docker stack ls`，`docker stack services wordpress` 和 `docker stack ps wordpress` 查看 Stack 裡面 Service 部署的情況
5. 打開瀏覽器進入任何一台虛擬機的 ip，都可以開啟 WordPress 的服務，確認安裝完成之後，就可以用 `docker stack rm wordpress` 把 Stack 刪除
### Docker Secret 的管理和使用
1. MySQL 的密碼屬於敏感資訊，在 Production 的情況下，要避免直接放在 docker-compose 裡面，所以就需要 Docker Secret
    - 什麼是 Secret？
        - 用戶名密碼
        - SSH Key
        - TLS 認證
        - 任何不想被看到的數據
2. 在 Manager 節點會有基於 Raft 的分布式儲存，它能讓 Manager 之間的節點同步，而且存在內置的分佈式儲存的數據是加密的，Manager 和 Worker 之間的通信也通過 TLS 加密，像是 Private Key 也都加密過後存在 Manager 節點的硬碟上的

<img src="/images/learning/docker-2/DockerDay06-Image07.png">

3. Secret Management
    - 存在 Manager 節點 Raft 資料庫裡
    - Secret 可以指定給一個 Service，這個 Service 就能看到這個 Secret
    - 在 Container 內部 Secret 看起來像是文件，但實際是在記憶體中
4. 在 Manager 節點新增一個檔案 `vim password` 並輸入 `admin123`，再將此檔案新增為 Secret Key
`docker secret create my-pw password`
5. 使用 `docker secret ls` 就可以看到剛剛新增的 Key 了
6. 上面的方法是用檔案新增 Key，也可以透過直接在指令回傳密碼的方式新增
`echo "adminadmin" | docker secret create my-pw2 -`
7. 可以使用 `docker secret ls` 就可以查看到有兩個密碼了，也可以用 `docker secret rm my-pw` 刪除不要的密碼
8. 可以直接在新增 Service 的時候把 key 加上去
`docker service create --name client --secret my-pw2 busybox sh -c "while true; do sleep 3600; done"`
9. 我們可以直接進去 Service 查看密碼，就會在 /run/secrets/ 目錄下看到原始的密碼
`docker exec -it client.1.k88i6xpjbtq34jk5vodnmxgby sh`
`cat /run/secrets/my-pw2`
10. 透過 Secret Key 創建 MySQL
`docker service create --name db --secret my-pw2 -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/my-pw2 mysql`
11. 找到 MySQL 所在的 Node 進入 MySQL 裡面
`docker exec -it db.1.ygxjss26mnd4bj3t1w46xeop7 sh`
12. 確認 Secret Key 是否存在
`ls /run/secrets`
13. 嘗試使用 Secret Key 登入 MySQL，可以成功登入，證明 Secret Key 生效了
`mysql -u root -p`
### Docker Secret 在 Stack 中的使用
1. 修改 docker-compose.yml 的 Secret Key 對應部分
```
version: '3.1'

services:

  web:
    image: wordpress
    ports:
      - 8080:80
    secrets:
      - my-pw2
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_PASSWORD_FILE: /run/secrets/my-pw2
    networks:
      - my-network
    depends_on:
      - mysql
    deploy:
      mode: replicated
      replicas: 3
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
      update_config:
        parallelism: 1
        delay: 10s

  mysql:
    image: mysql:5.7
    secrets:
      - my-pw2
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/my-pw2
      MYSQL_DATABASE: wordpress
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - my-network
    deploy:
      mode: global
      placement:
        constraints:
          - node.role == manager

volumes:
  mysql-data:

networks:
  my-network:
    driver: overlay

secrets:
  my-pw2:
    external: true
```
2. 啟動 WordPress 的 Stack `docker service deploy wordpress -c=docker-compose.yml`
3. 可以查看 Stack Service 狀態 `docker stack services wordpress`
4. 打開瀏覽器，安裝 WordPress 確定網站正常運行
### Service 更新
1. 在運行狀態下更新 Service，而 Service 是運行在 Production 環境下面的，在更新狀態下，我們要避免服務停止
2. 首先，新增一個 demo 的 Overlay 網路
`docker network create -d overlay demo`
3. 新建一個 web 的 Service
`docker service create --name web --publish 80:5000 --network demo fishboneapps/python-hello-world:1.0`
4. 啟動完成之後，先進行 Scale
`docker service scale web=2`
5. 查看 Service 狀態
`docker service ps web`
6. 檢查一下現在的服務狀態，會看到現在顯示 Hello Docker, Version 1.0
`curl 127.0.0.1`
7. 在 Worker1 上進行循環 curl，讓我們查看在更新的過程中，服務是否中斷
`sh -c "while true; do curl 127.0.0.1&sleep 1; done"`
8. 使用 `docker service update` 進行更新，可以更新 Secret Key、Publish Port 和 Image 等等
`docker service update --image fishboneapps/python-hello-world:2.0 web`
9. 會發現在 Workder1 上面的 curl 會自動跳成 2.0，且服務沒有中斷，這時候可以透過 `docker service ps web` 查看到服務更新的過程
10. 測試更新 Service 端口，更新端口業務一定會中斷，因為訪問都是透過 vip + 端口去實現的，如果端口改變了，vip 的端口也會改變
`docker service update --publish-rm 80:5000 --publish-add 8080:5000 web`
11. Docker Stack 沒有更新的功能，只需要修改 docker-compose.yml，然後一樣執行 deploy 就會完成更新，流程跟 Service 一樣，docker-compose.yml 會有 update_config 的參數，它會依據這個 config 進行更新