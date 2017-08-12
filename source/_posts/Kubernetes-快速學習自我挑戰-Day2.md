---
title: Kubernetes 快速學習自我挑戰 Day2
thumbnail:
  - /blogs/images/learning/kubernetes/kubernetesday2.png
date: 2017-08-11 04:42:43
categories: 學習歷程
tags: Kubernetes
---
<img src="/blogs/images/learning/kubernetes/kubernetesday2.png">

***
### Kubernetes 觀念簡介
#### 建立 docker containers
1. 建立 container，可以使用 Docker Engine
2. 建立 Dockerfile 來執行就可以快速建立需要的 container
3. Docker build 可以手動執行，也可以透過像是 **jenkins** 的 CI/CD 軟體
#### 在 Kubernetes 上面運行應用程式
1. 運行**新建立**的應用在新的 Kubernetes cluster
2. 在我們要運行基於 image 之上的 container，我們需要創建 **pod definition**
    - **一個 pod** 就是一個應用運行在 Kubernetes 上面
    - 一個 pod 包含**一個或多個緊密耦合的容器**，如此一來可以形成一個應用
        - 這些應用們可以輕易的使用本地 **port number** 跟其它應用溝通
    - 我們的應用只包含一個 container
3. 創建一個 pod
    - 創建一個 pod-helloworld.yml 的檔案
    - 使用 kubectl 在 kubernetes cluster 上面創建 pod
4. 有用的命令
    - kubectl get pod：取得所有在運行的 pods 的資訊
    - kubectl describe pod <pod>：描述一個 pod
    - kubectl expose pod <pod> --port=444 --name=fronted：公開一個 pod 的 port (創建一個新服務)
    - kubectl port-forward <pod> 8080：Port 傳送公開的 pod port 到自己的本地機器
    - kubectl attach <podname> -i：連接到特定 pod
    - kubectl exec <pod> --command：執行一個命令在 pod 上面
    - kubectl label pods <pod> myloable=awesome：新增一個標籤到 pod 上面
    - kubectl run -i --tty busybox --image=busybox --restart=Never -- sh：在 pod 裡面運行一個 sh - 對除錯非常有用
5. 先用 `minikube start` 運行 minikube，再用 `kubectl create -f first-app/helloworld.yml` 創建 pod
6. `kubectl describe pod nodehelloworld.example.com`
7. `kubectl port-forward nodehelloworld.example.com 8081:3000`
8. `curl localhost:8081` 就可以看到服務運行了
9. `kubectl expose pod nodehelloworld.example.com --type=NodePort --name nodehelloworld-service`
10. `minikube service <Service Name> --url` 即可以取得服務的 url
#### 有用的 kubectl commands
1. `kubectl attach nodehelloworld.example.com` 連接 nodehelloworld.example.com
2. `kubectl exec nodehelloworld.example.com -- ls /app` 在應用裡面執行命令
3. `kubectl exec nodehelloworld.example.com -- touch /app/test.txt`
4. `kubectl exec nodehelloworld.example.com -- ls /app`
5. `kubectl describe service nodehelloworld-service`
6. `kubectl run -i --tty busybox --image=busybox --restart=Never -- sh` 新增一個 box 來和 nodehellowrold-service 進行連線
    - `telnet 172.17.0.4 3000`
    - `GET /`
#### 負載平衡服務
1. 在真實的世界裡面，必須要可以從 cluster 的**外部**連線到應用
2. 在 AWS 上面，可以輕鬆的新增 **外部負載平衡器(external Load Balancer)**
3. 這個 AWS Load Balancer 將會路由到正確的 Kubernetes pod
4. 其它雲端服務商沒有 Load Balancer，但是仍有其它解決方案
    - 擁有 **haproxy/nginx** load balancer 在 cluster 之前
    - 或是可以直接將 ports 公開
#### AWS ELB LoadBalancer 服務
1. `kops create cluster --name=kubernetes.appsoliloquy.com --state=s3://kops-state-b429d --zones=ap-northeast-1a --node-count=2 --node-size=t2.micro --master-size=t2.micro --dns-zone=kubernetes.appsoliloquy.com`
2. `kops update cluster kubernetes.appsoliloquy.com --yes --state=s3://kops-state-b429d`
3. `kubectl create -f first-app/helloworld.yml`
4. `kubectl create -f first-app/helloworld-service.yml`
5. 進去 EC2 的 Load Balancer，確認資料狀態。
6. 進入 Route 53，新增 record，名稱設為 helloworld，Alias 設為 yes，Alias Target 設為 Loadbalancer，點選 create。
7. 進入 helloworld.kubernetes.appsoliloquy.com. 就可以看到結果了
### Kubernetes 基礎
#### Node 架構
1. Docker 裡面裝有 Pods，Pods 裡面裝有 containers
2. container 之間可以簡單地互相溝通
3. kubelet 用來管理 pods，在 container 之外，kube-proxy 負責和 iptable 溝通，如果 pod 有問題，它會更新 iptable 的規則
#### Replication Controller
1. 如果應用是 **stateless**，可以橫向的擴展
    - Stateless 就是應用沒有 **state**，不需要**寫入**任何**本地檔案**/保存本地 sessions
    - 所有傳統的資料庫(MySQL、Postgres)都是 **stateful**，它們都有資料庫檔案且不能分到多個 instances
2. 大部分的**網頁應用**可以做成 stateless
    - **Session 管理** 必須要在 container 之外完成
    - 任何檔案需要被儲存的**都不能儲存在 container 的本機**
3. 我們的範例應用是 **stateless**，如果相同的應用執行很多次，也不會改變它的 state
4. 更多關於練習的資訊，請看 [12factor.net](https://12factor.net/)
    - 或是看 **Learn DevOps**: Continuously delivering better software/scalig apps on-premise and in the cloud
5. 後面會解釋如何使用 **volumes** 來運行 stateful 應用
    - 這些 stateful 應用不能橫向擴展，但是可以在單一 container 裡面運行它們且**縱向擴展** (分配更多 CPU/記憶體/硬碟)
6. Kubernetes 的擴展可以透過使用 **Replication Controller** 來完成
7. Replication Controller 可以**確保**指定數量的 **pod relicas** 將會隨時運行
8. 如果被 relica controller 創建出來的 pod 運行失敗、被刪除或是被終止，那麼 pod 就會自動被取代
9. 如果你只想確保**一個 pod**是永遠運行的，甚至在重新開機之後，那麼使用 Replication Controller 是被推薦的
    - 可以只與**一個 replica** 運行一個 Replication Controller
    - 這樣可以確保 pod 總是處於運行狀態
10. 在 YAML 裡面設定 kind 為 ReplicationController、spec 裡面的 replicas 設為 2，即可複製應用兩次
#### Demo：Replication Controller
1. `kubectl create -f replication-controller/helloworld-repl-controller.yml`
2. `kubectl describe pod helloworld-controller-cwbbn` 複製其中的 controller 檢查狀態
3. `kubectl scale --replicas=4 -f replication-controller/helloworld-repl-controller.yml` 擴展服務
4. `kubectl get rc`
5. `kubectl scale --replicas=1 rc/helloworld-controller`
6. `kubectl delete rc/helloworld-controller`
#### 部署
1. **Replication Set** 是 Replication Controller 的下個世代
2. 它支援一種新的 selector，這個 selector 可以做基於**過濾**的 selection，而**過濾**是根據 **sets of values**
    - 例如："environment" 不是 "dev" 就是 "qa"
    - 不只根據 equality，就像是 Replication Controlller
        - 例如 "environment" == "dev"
3. 跟 Replication Controller 相比，**Replica Set** 是使用 Deployment object
4. Kubernetes 裡的部署聲明允許讓應用做**部署**和**更新**
5. 當使用 deployment object，你就定義了你的應用的 state
    - Kubernetes 將會確保 clusters 符合你的 **desired** state
6. 只使用 **replication controller** 或 **replication set** 可能會在部署應用的時候**很麻煩**
    - **Deployment Obeject** 比較容易使用且有更多可能性
7. 有 deployment object，你可以：
    - **創建**一個 deployment(例如：部署一個應用)
    - **更新**一個 deployment(例如：部署一個新版本)
    - 可以做 **rolling updates**(零停機時間部署)
    - **Roll back** 到上一版本
    - **停止/恢復**一個 deployment(例如：只推出部分比例)
8. 在 YAML 裡面設定 kind 為 Deployment
9. 非常有用的命令：
    - `kubectl get deployments`：取得現有的 deployments 資訊
    - `kubectl get rs`：取得 replica sets 的資訊
    - `kubectl get pods --show-labels`：取得 pods 且顯示連結到這些 pods 的 labels
    - `kubectl rollout status deployment/helloworld-deployment`：取得 deployment 狀態
    - `kubectl set image deployment/helloworld-deployment k8s-demo=k8s-demo:2`：運行 image label version 2 的 k8s-demo
    - `kubectl edit deployment/helloworld-deployment`：編輯 deployment object
    - `kubectl rollout status deployment/hellowrold-deployment`：取得 rollout 的狀態
    - `kubectl rollout history deployment/helloworld-deployment`：取得 rollout 的歷史
    - `kubectl rollout undo deployment/helloworld-deployment`：Rollback 到上一版本
    - `kubectl rollout undo deployment/helloworld-deployment --to-revision=n`：Rollback 到任何版本
#### Demo：部署
1. `kubectl create -f deployment/helloworld.yml`
2. `kubectl get deployments`
3. `kubectl get rs`
4. `kubectl get pods`
5. `kubectl get pods --show-labels`
6. `kubectl rollout status deployment/helloworld-deployment`
7. `kubectl expose deployment helloworld-deployment --type=NodePort`
8. `kubectl describe service helloworld-deployment`
9. `minikube service helloworld-deployment --url`
10. `kubectl set image deployment/helloworld-deployment k8s-demo=wardviaene/k8s-demo:2`
11. `kubectl rollout status deployment/helloworld-deployment`
12. `curl http://192.168.99.100:32635` curl 剛剛取得的 ip，就會發現變成 Helloworld v2
13. `kubectl rollout history deployment/helloworld-deployment`
14. `kubectl rollout undo deployment/helloworld-deployment`
15. `kubectl rollout status deployment/helloworld-deployment`
16. `kubectl edit deployment/helloworld-deployment`，在 spec 的 replica 下面新增 `revisionHistoryLimit: 100`
17. `kubectl set image deployment/helloworld-deployment k8s-demo=wardviaene/k8s-demo:2`
18. `kubectl rollout history deployment/helloworld-deployment`
19. `kubectl rollout undo deployment/helloworld-deployment --to-revision=8`
20. `kubectl rollout history deployment/helloworld-deployment`