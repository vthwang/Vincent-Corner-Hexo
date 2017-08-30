---
title: Kubernetes 快速學習自我挑戰 Day6
thumbnail:
  - /blogs/images/learning/kubernetes/kubernetesday6.png
date: 2017-08-29 09:40:46
categories: 學習歷程
tags: Kubernetes
---
<img src="/blogs/images/learning/kubernetes/kubernetesday6.png">

***
### Kubernetes 管理
#### Kubernetes 的 Master 服務
1. Kubectl 要和 REST 介面溝通，在溝通之前，要做 authorization
2. Kubernetes 用 etcd 當作後端
3. Scheduler 會負責排程 pod，可以使用預設的或是外掛
#### 資源配額
1. 當 Kubernetes cluster 被很多**人**或**團隊**使用的時候，**資源管理**變得非常重要
    - 你想要能夠**管理資源**，你可以給一個人或一個團隊
    - 你不想要一個人或團隊**占用 cluster 的所有資源**(例如：CPU 或記憶體)
2. 可以使用 **namespaces** 來分離 cluster 且在上面啟用資源配額
    - 可以用 **ResourceQuota** 和 **ObjectQuota** objects 來實現
3. 每一個 container 都可以指定 **request capacity** 和 **capacity limits**
    - **Request capacity** 對資源來說是一種明確的請求
        - Scheduler 可以使用 **request capacity** 來決定要把 pod 放在哪裡
        - 可以看成 **pod 需要的最少資源量**
    - **Resource limit** 是一種對 container 的限制規定
        - container 沒辦法利用比指定更多的資源
4. resource quotas 範例
    - 運行一個 **CPU resource** request 為 **200m** 的 **deployment** 在 **pod** 上面
    - 200m = 200millicpu (或是 200 millicores)
    - 200m = 0.2 也就是運行 node 的 CPU 核心的 20%
        - 如果 node 是雙核心，它還是只有單核心的 20%
    - 也可以限制它，例如：400m
    - Memory quotas 用 MiB 或 GiB 來定義
5. 如果一個 capacity quota (例如：記憶體/cpu) 已經被管理者指定，那麼在創建 pod 的時候一定要指定 capacity quota
    - 管理者可以為 pod 指定預設 request 值，且不需要為 capacity 指定任何值
    - 對 limit quotas 一樣有效
6. 如果資源被請求的次數高於允許的 capacity，伺服器 API 會丟出 403 FORBIDDEN 錯誤，且 kubectl 會顯示錯誤
7. 管理者可以用一個 namespace 設定以下 resource limits

| Resource | Description |
| :-------------: | :---------------: |
| requests.cpu | 全部 pods 的 **CPU requests** 總和不能超過這個值 |
| requests.mem | 全部 pods 的 **MEM requests** 總和不能超過這個值 |
| requests.storage | 全部 persistent volume 的 **storage requests** 總和不能超過這個值 |
| limits.cpu | 全部 pods 的 **CPU limits** 總和不能超過這個值 |
| limits.memory| 全部 pods 的 **MEM limits** 總和不能超過這個值 |
8. 管理者可以設定以下 objects limits

| Resource | Description |
| :-------------: | :---------------: |
| configmaps | 可以存在 namespace 的 **configmaps** 總數 |
| persistentvolumeclaims | 可以存在 namespace 的 **persistent volume claims** 總數 |
| pods | 可以存在 namespace 的 **pods** 總數 |
| replicationcontrollers | 可以存在 namespace 的 **replicationcontrollers** 總數 |
| resourcequotas | 可以存在 namespace 的 **resource quotas** 總數 |
| services | 可以存在 namespace 的 **services** 總數 |
| services.loadbalancer | 可以存在 namespace 的 **load balancers** 總數 |
| services.nodeports | 可以存在 namespace 的 **nodeports** 總數 |
| secrets | 可以存在 namespace 的 **secrets** 總數 |
#### Namespaces
1. Namespaces 可以在 phisical cluster 裡面創建 **virtual cluster**
2. Namespaces **有邏輯的分離** cluster
3. 標準的 namespace 叫做 "**default**"，而且那是所有資源預設啟動的地方
    - 另外一個為 Kubernetes 特定資源擁有的 namespace，叫做 **kube-system**
4. Namespaces 是有必要的，當同時有**很多團隊/專案**使用 kubernetes cluster
5. 資源名稱在一個 namespace 必須要是獨一無二的，而且不能跨越 namespaces
    - 例如：在不同 namespaces 可以擁有叫做 "helloworld" 的 deployment 很多次，但是在一個 namespace 不能有兩次
6. 可以使用 namespaces 來分開一個 Kubernetes cluster 的資源
    - 你可以以每一個單一 namespace 為基礎來限制資源
    - 例如：市場組只能使用最多 10 GiB 的記憶體、2 個 Loadbalancers、2 核心 CPU
7. 首先，你必須要先創建一個 namespace
`kubectl create namespace myspace`
8. 你可以列出所有 namespaces
`kubectl get namespaces`
9. 如果想要設定預設 namespace 來啟動資源
`export CONTENT=$(kubectl config view | awk '/current-context/ {print $2}'`)
`kubectl config set-context $CONTEXT --namespace=myspace`
10. 接下來可以在 namespace 建立 resource limits
```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
  namespace: myspace
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```
11. 也可以建立 object limits：
```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-counts
  namespace: myspace
spec:
  hard:
    configmaps: "10"
    persistentvolumeclaims: "4"
    relicationcontrollers: "20"
    secrets: "10"
    services: "10"
    services.loadbalancers: "2"
```
#### Demo：Namespace quotas
1. `cat resourcequotas/resourcequota.yml`
2. `kubectl create -f resourcequotas/resourcequota.yml`
3. `cat resourcequotas/helloworld-no-quotas.yml`
4. `kubectl create -f resourcequotas/helloworld-no-quotas.yml`
5. `kubectl get deploy --namespace=myspace`
6. `kubectl get rs --namespace=myspace`
7. `kubectl describe rs/helloworld-deployment-4153696333 --namespace=myspace`
會發現出現錯誤 failed quota，因為沒有指定限定資源，而本身 namespace 有限定資源
8. `kubectl delete deploy/helloworld-deployment --namespace=myspace`
9. `cat resourcequotas/helloworld-with-quotas.yml`
10. `kubectl create -f resourcequotas/helloworld-with-quotas.yml`
11. `kubectl get pod --namespace=myspace`
這邊會發現，我明明要求三個 replicas，可是只出現兩個
12. `kubectl get rs --namespace=myspace`
13. `kubectl describe rs/helloworld-deployment-1576367412 --namespace=myspace`
14. `kubectl get quota --namespace=myspace`
15. `kubectl describe quota/compute-quota --namespace=myspace`
16. `kubectl delete deploy/helloworld-deployment --namespace=myspace`
17. `cat resourcequotas/defaults.yml`
18. `kubectl describe limits limits --namespace=myspace`
19. `kubectl create -f resourcequotas/helloworld-no-quotas.yml`
20. `kubectl get pods --namespace=myspace`
#### User 管理
1. 有**兩種** users 可以創建
    - **Normal user**，可以外部存取 user
        - 例如：through kubectl
        - 這個 user 不能使用 object 來管理
    - **Service user**，可以在 Kubernetes 用 object 管理的 user
        - 這個類型的 user 只能用在 cluster **裡面 authenticate**
        - 例如：從 pod 裡面，或從 kubelet
        - 這些 credentials 被像是 **Secrets** 管理
2. 對 normal users 有很多 **authentication strategies**
    - Client Cetificates
    - Bearer Tokens
    - Authentication Proxy
    - HTTP Basic Authentication
    - OpenID
    - Webhooks
3. Service Users 使用 **Service Account Tokens**
4. 它們被儲存為 **credentials 且使用 Secrets**
    - 那些 Secrets 被掛接在 pods 裡面來讓服務之間溝通
5. Service Users **對 namespace 是特定的**
6. 它們被用 API 自動建立或使用 **objects** 手動建立
7. 任何 API 被稱為 **not authenticated** 被視為 **anonymous** user
8. 獨立在認證機制之外，normal users 有以下特質：
    - 一個 Username (例如：user123 或 user@email.com)
    - 一個 UID
    - Groups
    - 其它儲存其它資訊的 field
9. 在一個 normal users authenticate 之後，他就可以存取所有東西
10. 為了**限制**存取，你必須設定 **authorization**
11. 以下有幾種選項可以選擇：
    - AlwaysAllow / AlwaysDeny
    - ABAC (Attribute-Based Access Control)
    - RBAC (Role Based Access Control)
    - Webhook (從遠端 service 做 authorization)
12. Authorization 還在更新中
13. The ABAC 必須要**手動**設定
14. RBAC 使用 [rbac.authorization.k8s.io](rbac.authorization.k8s.io) **API** group
    - 這允許 admins 可以**透過 API** 來**動態**設定權限
15. 在 Kubernetes 1.3 RBAC 還在 **alpha** 而且甚至被當作**實驗性的**
    - RBAC 是很有展望的而且會變成 **stable**
    - 關於 ABAC/RBAC 的目前狀況，可以參照 [Kubernetes Authorization](https://kubernetes.io/docs/admin/authorization/)
#### Networking
1. Networking 的方法跟預設 Docker 設定非常不一樣
2. 在這個課程包含：
    - 在 pod 裡面 **Container to container** 的溝通
        - 透過 **localhost** 和 **port number**
    - **Pod-To-Service** 通訊
        - 使用 **NodePort** 或 **DNS**
    - **External-To-Service**
        - 使用 **LoadBalancer、NodePort**
3. 在 Kubernetes，pod 本身應該要總是可以 routeable
4. 這是 **Pod-to-Pod** 通訊
5. Kubernetes 假設 pods 應該要能夠跟其它 pods 溝通，不論它們運行在哪個 node 上面
    - 每一個 pod 都有它自己的 IP 位址
    - 在不同 nodes 上的 pods 必須要能夠跟其它使用 IP 位址的 pod 溝通
        - 在實作上會根據你的網路設定而有不同
6. 在 AWS：**kubernets networking** (kops default)
    - 每一個 pod 可以使用 AWS Virtual Private Network (VPC) 得到 routable 的 IP
    - kubernetes master 分配一個 /24 subent 給每一個 node (254 IP 位址)
    - 這個 subnet 會被新增到 VPCs route table
    - 有限制 **50 個 entries**，也就是說，你不能夠建立超過 50 個 node 在單一 AWS cluster
        - 雖然，AWS 可以把 limit 改到 100，但是可能會**影響效能**
7. 並不是每個主機商都有 VPC-technology (雖然 GCP 和 Azure 都有)
8. 還有其它**替代方案**
    - Container Network Interface (CNI)
        - 軟體會提供在 containers 裡的 network interfaces 的函式庫/外掛
        - 熱門的解決方案包含 **Calico**、**Weave** (standalone or with CNI)
    - **Overlay Network**
        - **Flannel** 是一個簡單又熱門的方式 
#### Node Maintenance
1. 這是 **Node Controller**，它負責管理 Node Objects
    - 它分派 **IP space** 給 node，當新的 node 啟動的時候
    - 它使可用機器的 **node list** 維持最新
    - node controller 也監控 **node 的健康狀態**
        - 如果 node 不健康，它就會被刪除
        - Pods 運行在不健康的 node 會 rescheduled
2. 當新增新的 node，**kubelet** 會企圖自行註冊
3. 這個叫做 **self-registration**，而且是預設的行為
4. 它允許你**簡單的新增更多 nodes** 到 cluster，且不需要自己修改 API
5. 一個新的 node object 會**自動**帶有以下內容進行建立
    - metadata (帶有名稱：IP 或 hostname)
    - Labels (例如：cloud region / availability zone / instance size)
6. 一個 node 也有 **node condition** (例如：Ready、OutOfDisk)
7. 當你想要 **decommission** 一個 node，你想要優雅地做
    - 你要 drain 一個 node 在你關閉它或是把它拿移出 cluster
8. 為了 drain 一個 node，可以用以下指令
`kubectl drain nodename --grace-period=600`
9. 如果 nodes 運行 pods 且不受 controller 控制，那就是一個單一 pod
`kubectl drain nodename --force`
#### Demo：Node Maintenance
1. `kubectl create -f deployment/helloworld.yml`
2. `kubectl get pod`
3. `kubectl drain minikube --force`
4. `kubectl get node`
5. `kubectl get pod`
#### High Availability
1. 如果想要運行 cluster 在產品上，你會想要所有的 master services 有 **high availability (HA)** 設置
2. 設定會像是這樣：
    - **Clustering etcd**：至少運行三個 etcd nodes
    - 使用一個 LoadBalancer 去**複製 API servers**
    - 運行很多 **scheduler** 和 **controllers** 的 instances
        - 只有其中一個會是 leader，其它的都會 stand-by
3. 像是 minikube 的 cluster 不需要 HA - 它是單一 node cluster
4. 如果要在 AWS 使用產品化 cluster，**kops** 可以為你做 heavy lifting
5. 如果你運行在其它雲端平台，看看針對那個平台的 **kube deployment tools**
    - **kubeadm** 是一個 tool 可以為你設置 cluster
6. 如果你使用某個平台且不使用任何工具，可以看看[文件](https://kubernetes.io/docs/admin/high-availability/)來自行實作
#### Demo：High Availability
1. `kops create cluster --name=kubernetes.appsoliloquy.com --state=s3://kops-state-qq123 --zones=ap-southeast-2a,ap-southeast-2b,ap-southeast-2c --node-count=2 --node-size=t2.micro --master-size=t2.micro --dns-zone=kubernetes.appsoliloquy.com --master-zones=ap-southeast-2a,ap-southeast-2b,ap-southeast-2c`
2. `kops edit ig --name=kubernetes.appsoliloquy.com nodes --state=s3://kops-state-qq123`
3. `kops edit ig --name=kubernetes.appsoliloquy.com master-ap-southeast-2a --state=s3://kops-state-qq123`
4. `kops edit ig --name=kubernetes.appsoliloquy.com master-ap-southeast-2b --state=s3://kops-state-qq123`
***
### 完成課程
<img src="/blogs/images/learning/kubernetes/Edward Viaene_Kubernetes.jpg">