---
title: docker 快速學習自我挑戰 Day7
thumbnail:
  - /blogs/images/learning/docker/dockerday7.png
date: 2017-08-01 18:38:10
categories: 學習歷程
tags: Docker
---
<img src="/blogs/images/learning/docker/dockerday7.png">

***
### Docker 服務和 Swarm 的威力： Build-In Orchestration
#### Swarms Stacks 和產品化等級的 Compose
1. 在 1.13 版本，Docker 增加了一個新的抽象層到 Swarm，且命名為 Stacks
2. Stacks 接受的 Compose files 如同他們對 Services、Networks 和 Volumes 的聲明性定義
3. 我們使用 `docker stack deploy` 而不是 docker service create
4. Stacks 為我們掌管這些 objects，包括每一個 stack 的 overlay network，新增 stack 名稱來開始他們的名稱
5. 新的 `deploy`：Compose file 裡面的 key，不能用 `build`
6. Compose 現在省略 `deploy`，Swarm 省略 `build`
7. `docker-compose` cli 在 Swarm server 上面不被需要
8. `docker stack deploy -c example-voting-app-stack.yml voteapp` 使用 YAML 檔案開始部署專案
9. `docker stack ps voteapp` 檢查運行狀態
10. `docker stack services voteapp` 顯示 server 狀態，有點像是 `docker service ls`
11. 如果檔案有修改，再執行一次 `docker stack deploy -c example-voting-app-stack.yml voteapp` 就會自動更新了
#### 給 Swarm 使用的 Secrets Storage：保護你的環境變數
1. 給 Swarm 儲存 Secrets 的最簡單的「安全」解決方案 
2. 什麼是 Secret？
    - Usernames and passwords
    - TLS 認證和 keys
    - SSH keys
    - 任何你將不會放在「前端頁面的新聞」的資料
3. 支援 generic strings 或二進位內容，最多不可大於 500kb
4. 不需要要求 apps 可以被覆寫
5. 在 1.13.0 版本後的 Docker，Swarm Raft DB 在硬碟上是被加密的
6. 只儲存在 Manager nodes 的硬碟上
7. 預設 Managers 和 Workers 「控制面板」是 TLS ＋ 雙向認證
8. Secrets 首先儲存在 Swarm，然後再分派給 Service(s)
9. 只有在被分派的 Service(s) 的 containers 可以看見它們
10. 它們看起來是 container 裡面的檔案，但事實上它們在記憶體上的 fs
11. `/run/secrets/<secret_name>` 或`/run/secrets/<secret_alias>`
12. 本地端的 docker-compose 可以使用基於檔案的 secrets，但是不安全
#### 在 Swarm Services 使用 Secrets
1. `docker secret create psql_user psql_user.txt`
2. `echo "myDBpassWORD" | docker secret create psql_pass -`
3. `docker service create --name psql --secret psql_user --secret psql_pass -e POSTGRES_PASSWORD_FILE=/run/secrets/psql_pass -e POSTGRES_USER_FILE=/run/secrets/psql_user postgres`
4. `docker service ps psql` 觀察在第幾個 node，跳到那個 node
5. `docker exec -it <container> bash`
6. `cat /run/secrets/psql_user` 可以直接看到 psql_user 內容
7. `docker service update --secret-rm` 可以使用這個語法移除 secrets
#### 與 Swarm Stacks 一起使用 Secrets
1. `docker stack deploy -c docker-compose.yml mydb`
2. `docker stack rm mydb`
#### 與本地端 Docker Compose 一起使用 Secrets
1. `docker-compose up -d`
2. `docker-compose exec psql cat /run/secrets/psql_user`
#### 作業：創建一個帶有 Secrets 的 Stack 並且 Deploy
1. 使用上一個作業(**compose-assignment-2**)的 Drupal compose 檔案
2. 重新命名 image 回到官方版本 **drupal:8.2**
3. 移除 **build:**
4. 透過 **external:** 新增 secret
5. 使用環境變數 **POSTGRES_PASSWORD_FILE**
6. 透過 cli **echo "\<pw\>" | docker secret create psql-pw -** 新增 secret
7. 複製 compose 到 Swarm node1 的 新 yml 檔案
#### 答案：創建一個帶有 Secrets 的 Stack 並且 Deploy
1. 新增 docker-compose.yml
```
version: '3.1'

services:

  drupal:
    image: drupal:8.3.5
    ports:
      - "80:80"
    volumes:
      - drupal-modules:/var/www/html/modules
      - drupal-profiles:/var/www/html/profiles
      - drupal-sites:/var/www/html/sites
      - drupal-themes:/var/www/html/themes

  postgres:
    image: postgres:9.6
    environment:
      - POSTGRES_PASSWORD=/run/secrets/psql-pw
    secrets:
      - psql-pw
    volumes:
      - drupal-data:/var/lib/postgresql/data

volumes:
  drupal-data:
  drupal-modules:
  drupal-profiles:
  drupal-sites:
  drupal-themes:

secrets:
  psql-pw:
    external: true
```
2. `echo "123456" | docker secret create psql-pw -`
3. `docker stack deploy -c docker-compose.yml drupal`
4. `docker stack ps drupal`
#### 完整的 App 生命週期：與單一 Compose 設計的 Dev、Build 和 Deploy
1. 保持夢想
2. 一組 Compose files 給：
    - 本機端 **docker-compose up** 開發環境
        - `docker-compose up -d`
        - `docker-compose down`
    - 遠端 **docker-compose up** CI 環境
        - `docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d`
    - 遠端 **docker stack deploy** 產品化環境
        - `docker-compose -f docker-compose.yml -f docker-compose.prod.yml config > output.yml`
3. 筆記：`docker-compose -f a.yml -f b.yml config` 大部分可以運作
4. 筆記：Compose **extends**：尚無法再 Stacks 裡運作