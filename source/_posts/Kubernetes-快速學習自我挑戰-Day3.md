---
title: Kubernetes 快速學習自我挑戰 Day3
thumbnail:
  - /images/learning/kubernetes/kubernetesday3.png
date: 2017-08-15 04:47:58
categories: Study Note
tags: Kubernetes
---
<img src="/images/learning/kubernetes/kubernetesday3.png">

***
### Kubernetes 觀念簡介
#### Service
1. **Pods** 是非常**動態的**，它們在 Kubernetes 上面是來去自如的
    - 當使用 **Replication Controller**，pods 在擴展的操作時是**被終止的**且再被創建的
    - 當使用 **Deployments**，且在**更新** image 版本的時候，pods 會**被終止**且創建一個新的 pods 取代舊的
2. 這就是為什麼 pods 不應該被直接存取，而是透過 **Service**
3. 一個服務是在 "mortal" pods 和其它 **services** 或**終端使用者**之間的**邏輯橋樑**
4. 當使用 "kubectl expose" 命令，就會為 pod 創建一個新的服務，如此一來它就可以被外部存取
5. 創建一個服務會為 pod(s) 創建一個 endpoint
    - **ClusterIP**：一個虛擬 ip 位址只能從 cluster 裡面被存取(這是預設)
    - **NodePort**：在每一個 node 都使用一樣的 port，而且可以被外部存取
    - **LoadBalancer**：LoadBalance 是由**雲端主機商**建立的，它會路由外部網路到每一個在 NodePort 上的 node (AWS 上的 ELB 服務)
6. 以上所提到的選項可以使用的只有創建 **虛擬 IPs** 或 **ports**
7. 它還有使用 **DNS 名稱**的可能性
    - **ExternalName** 可以為 service 提供 DNS 名稱
    - 例如：為 service discovery 使用 DNS
    - 它只有在 **DNS add-on** 啟動的時候可以使用
8. 筆記：預設的服務只能運行在 30000-32767 port 之間，但是可以在 kube-apiserver 的命令 argument 加上 --service-node-port-range= 來改變這種特性 (在 init scripts)
#### Demo：Service
1. `kubectl create -f first-app/helloworld.yml`
2. `kubectl describe pod nodehelloworld.example.com`
3. `cat first-app/helloworld-nodeport-service.yml`
4. `kubectl create -f first-app/helloworld-nodeport-service.yml`
5. `minikube service helloworld-service --url`
6. `curl http://192.168.99.100:31001`
7. `kubectl describe svc helloworld-service`
8. `kubectl get svc`
9. `kubectl delete svc helloworld-service`
10. `kubectl create -f first-app/helloworld-nodeport-service.yml`
11. `kubectl describe svc helloworld-service`，會發現 ip 不一樣了
#### Labels
1. Labels 是 key/value pairs，而且可以連接到 objects
    - Labels 在 AWS 或其它雲端服務商裡就像 **tags** ，且用來標籤 resource
2. 可以 **label** objects，例如 pod，要跟隨以下組織架構
    - **Key**：environment - **Value**：dev/staging/qa/prod
    - **Key**：department - **Value**：engineering/finance/marketing
3. 在上一個範例，已經使用 label 來標籤 pods 了
4. Labels **不是獨一無二**且可以增加**多重標籤**到一個 object 上面
5. 一旦 labels 連結到 objects，就可以使用過濾器來縮小結果
    - 這叫做 **Label Selectors**
6. 使用 Label Selector 可以使用 **matching expressions** 來匹配 labels
    - 例如：特定的 pod 只能運行在「environment」標籤上的 node 等同於 「development」
    - 更複雜的匹配：「environment」必須要是「development」或「qa」
7. 也可以用 labels 來標籤 **nodes**
8. 一旦 nodes 被標籤，就可以使用 **label selector** 來讓 pods 只能運行在 **特定 nodes**
9. 在特定設置的 nodes 上運行一個 pod 有必要的**兩步驟**
    - 第一步驟要**標籤** node
    - 第二步驟要新增一個 **nodeSelector** 到 pod 組態設定
10. 第一步驟：新增一個或是多數 labels 到 nodes 上
`kubectl label nodes node1 hardware=high-spec`
`kubectl label nodes node2 hardware=low-spec`
11. 第二步驟：新增一個使用這些 labels 的 pod
#### Demo：使用 labels 的 Node Selector
1. `cat deployment/helloworld-nodeselector.yml`
2. `kubectl get nodes --show-labels`
3. `kubectl create -f deployment/helloworld-nodeselector.yml`
4. `kubectl get deployments`，這邊會發現新增出來的東西沒有 available
5. `kubectl get pods`，會發現都在 pending
6. `kubectl describe pod helloworld-deployment-4129182270-70sdz`，隨便選一個在 pending 的看內容，會發現錯誤在 MatchNodeSelector (1).
7. `kubectl label nodes minikube hardware=high-spec`
8. `kubectl get nodes --show-labels`，檢查是否有 hight-spec 的標籤
9. `kubectl get pods`，就會發現全部啟動了
10. `kubectl describe pod helloworld-deployment-4129182270-70sdz`，會看到 log 檔，發現啟動失敗，後來就可以啟動了
#### Health checks
1. 如果應用**壞掉了**，pod 和 container 仍然繼續運行，應用可能已經沒有再繼續運作了
2. 如果要**偵測**和**解決**應用的問題，可以運行**health checks**
3. 有以下兩種 health checks 可以執行
    - 在 container **定期**執行 **command**
    - 在 **URL** (HTTP)上定期檢查
4. 在 Load balancer 後的典型的產品化應用應該要總是有用某種方法執行的 **health checks** 來確保應用的**可用性**和**彈性**
5. 以下為 health checks 的範例
```
livenessProbe:
    httpGet:
        paht: /
        port: 3000
    initailDelaySeconds: 15
    timeoutSeconds: 30
```
#### Demo：Health checks
1. `kubectl create -f deployment/helloworld-healthcheck.yml`
2. `kubectl get pods`
3. `kubectl describe pod helloworld-deployment-583969349-0m0p8`，會發現裡面有一個 Liveness 的選項
4. `kubectl edit deployment/helloworld-deployment`，進去會看到 livenessProbe，可以進行編輯
#### Secrets
1. Secrets 提供一種在 Kubernetes 的方法，可以分配 **credentials**、**keys**、**passwords** 和 **"secret" data** 給 pods
2. Kubernetes 自己本身也使用 Secrets 機制來提供 credentials 以存取內部 API
3. 也可以使用**同樣的機制**來提供 secrets 給應用
4. Secrets 是一種提供 secrets 的方法，Kubernetes 原生的
    - 如果不想使用 Secrets，還是有**其它方法**可以讓 container 取得它的 secrets(例如：在應用裡使用 **external vault services**)
5. Secrets 可以使用以下方式來使用
    - 以**環境變數**的方法使用 Secrets
    - 在 pod 裡以**檔案**的方式使用 Secrets
        - 這個設定 **volumes** 一定要被掛接在 container 裡
        - 在這個 volume 有**檔案** 
        - 可以被使用在 **dotenv** 檔案或應用可以直接閱讀檔案
    - 使用 **external image** 來 pull secrets (從**private image registry**)
6. 使用檔案來產生 secrets
`echo -n "root" > ./username.txt`
`echo -n "password" > ./password.txt`
`kubectl create secret generic db-user-pass --from-file=./usernmae.txt --from-file=./password.txt`
7. secreat 可以是 SSH key 或是 SSL 憑證
`kubectl create secret generic ssl-certificate --from-file=ssh-privatekey=~/.ssh/id_rsa --ssl-cert=ssl-cert=mysslcert.crt`
8. 使用 YAML 產生 secrets
    - 使用 base64 產生 password 和 username
    `echo -n "root" | base64`
9. 完成創建 YAML 檔案，可以直接使用 kubectl 創建
`kubectl create -f secrets-db-secret.yml`
10. 可以創建 pods 並且 expose secrets 為環境變數
`name: SECRET_USERNAME`
11. 或者，也可以在檔案內提供 secrets
```
volumeMount:
-name: credvolume
 mountPath: /etc/creds
 readOnly: true
volumes:
-name: credvolume
secret:
 secretName: db-secrets
```
#### Demo：使用 Volumes 的 Credentails
1. `cat deployment/helloworld-secrets.yml`
2. `kubectl create -f deployment/helloworld-secrets.yml`
3. `cat deployment/helloworld-secrets-volumes.yml`
4. `kubectl create -f deployment/helloworld-secrets-volumes.yml`
5. `kubectl describe pod helloworld-deployment-292348803-34dq4`
6. `kubectl exec helloworld-deployment-292348803-34dq4 -i -t -- /bin/bash`
7. `cat /etc/creds/username`
8. `cat /etc/creds/password`
9. `mount`
#### Demo：在 kubernetes 上運行 WordPress
1. `cat wordpress/wordpress-secrets.yml`
2. `cat wordpress/wordpress-single-deployment-no-volumes.yml`
3. `kubectl create -f wordpress/wordpress-secrets.yml`
4. `kubectl create -f wordpress/wordpress-single-deployment-no-volumes.yml`
5. `kubectl get pods`
6. `kubectl describe pod wordpress-deployment-2401615361-1j6rw`
7. `cat wordpress/wordpress-service.yml`
8. `kubectl create -f wordpress/wordpress-service.yml`
9. `minikube service wordpress-service --url`
10. `kubectl delete pod/wordpress-deployment-2401615361-1j6rw`
11. `kubectl get pods`，刪除之後會發現 pod 依然還在
#### Web UI
1. Kubernetes 自帶 **Web UI**，可以取代 kubectl 指令
2. 它可以用來
    - cluster 上運行的應用**總覽**
    - **創建**和**修改**個別 Kubernetes **資源**和**工作量**(像是 kubectl create 和 delete)
    - 取得**資源狀態**的資訊(像是 kubectl describe pod)
3. 一般來說，可以用 https://<kubernetes0master>/ui 來存取 kubernetes Web UI
4. 如果不能存取(例如：部署類型沒有啟動功能)，可以手動安裝：
`kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml`
5. 如果被詢問密碼，可以用以下方式取得密碼
`kubectl config view`
6. 如果使用 minikube 可以使用下列命令啟動 dashboard
`minikube dashboard`
7. 如果想要知道 url
`minikube dashboard --url`
#### Demo：Web UI
1. `minikube dashboard --url`