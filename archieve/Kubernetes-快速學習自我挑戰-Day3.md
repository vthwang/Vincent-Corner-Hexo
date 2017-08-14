---
title: Kubernetes 快速學習自我挑戰 Day3
thumbnail:
  - /blogs/images/learning/kubernetes/kubernetesday3.png
date: 2017-08-12 04:47:58
categories: 學習歷程
tags: Kubernetes
---
<img src="/blogs/images/learning/kubernetes/kubernetesday3.png">

***
### Kubernetes 觀念簡介
#### Service
1. **Pods** 是非常**動態的**，它們在 Kubernetes 上面是來去自如的
    - 當使用 **Replication Controller**，pods 在擴展的操作時是**被終止的**且再被創建的
    - 當使用 **Deployments**，且在**更新** image 版本的時候，pods 會**被終止**且創建一個新的 pods 取代舊的
2. 這就是為什麼 pods 不應該被直接存取，而是透過 **Service**
3. 一個服務是在 "mortal" pods 和其它 **services** 和**終端使用者**之間的**邏輯橋樑**
4. 當使用 "kubectl expose" 命令，就會為 pod 創建一個新的服務，如此一來它就可以被外部存取
5. 創建一個服務會為 pod(s) 創建一個 endpoint
    - 一個 clusterIP：一個虛擬 ip 位址只能從 cluster 裡面被存取(這是預設)
    - 
6. 











