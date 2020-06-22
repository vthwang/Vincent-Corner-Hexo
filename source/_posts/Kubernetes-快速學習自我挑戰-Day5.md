---
title: Kubernetes 快速學習自我挑戰 Day5
thumbnail:
  - /images/learning/kubernetes/kubernetesday5.png
date: 2017-08-22 00:46:53
categories: Study Note
tags: Kubernetes
toc: true
---
<img src="/images/learning/kubernetes/kubernetesday5.png">

***
### 進階的主題
#### Volumes Autoprovisioning
1. Kubernetes plugins 可以**提供 storage**
2. **AWS Plugin** 可以藉由在 AWS 創建 volumes 來**提供 storage**，但是要在 volume 連接到 node 之前才能做
3. 這些可以使用 **StorageClass object** 來完成
    - [Documentation](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#storageclasses)
4. 使用 **auto provisioned volumes**，可以創建以下 yaml 檔案：
    - storage.yml
```
kind: StorageClass
apiVersion: storage.k8s.io/v1beta1
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  zone: us-east-1
```
5. 這樣可以創建 volume 並宣告使用 **aws-ebs provisioner**
6. Kubernetes 將會提供 type **gp2** 的 volume (一般用途 - SSD)
7. 接下來，可以創建 volume 並宣告和指定容量
    - my-volume.claim.yml
```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: myclaim
  annotations:
    volume.beta.kubernetes.io/storage-class: "standard"
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi
```
8. 最後，可以使用 volume 來啟動 pod
    - my-pod.yml
```
kind: Pod
apiVersion: v1
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```
#### Demo：使用 Volumes 的 WordPress
1. `cd wordpress-volumes` 
2. `cat storage.yml`
3. `cat pv-claim.yml`
4. `cat wordpress-db.yml`
5. `cat wordpress-db-service.yml`
6. `cat wordpress-secrets.yml`
7. `cat wordpress-web.yml`
8. `cat wordpress-web-service.yml`
9. [查詢 AWS 服務區域](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region)
`aws efs create-file-system --creation-token 1 --region ap-southeast-2`
10. 找尋 SubnetId 和 SecurityGroups
`aws ec2 describe-instances --region ap-southeast-2`
11. `aws efs create-mount-target --file-system-id fs-518f6c68 --subnet-id subnet-5ed8c73a --security-groups sg-5154a737 --region ap-southeast-2`
12. 修改倒數第二行的 server
`vim wordpress-web.yml`
13. `kubectl create -f storage.yml`
14. `kubectl create -f pv-claim.yml`
15. `kubectl create -f wordpress-secrets.yml`
16. `kubectl create -f wordpress-db.yml`
17. `kubectl create -f wordpress-db-service.yml`
18. `kubectl get pvc`
19. `kubectl get pod`
20. `kubectl describe pod wordpress-db-8n665`
21. `kubectl create -f wordpress-web.yml`
22. `kubectl create -f wordpress-web-service.yml`
23. 去 Route53 新增一個 DNS record - wordpress.<domain>，在 alias 的地方打勾，選擇剛剛建立的 LoadBalancer
24. `kubectl edit deployment/wordpress-deployment` 把以下五行加到 35 行之後，把後面 env 縮排進去並刪除 -，完成之後就發現 wordpress 可以上傳圖片了
```
- command:
  - bash
  - -c
  - chown www-data:www-data /var/www/html/wp-content/uploads && docker-entrypoint.sh apache2-foreground
  env: 
  - name: 
```
25. `kubectl get pod`
26. 刪除所有的 pod，就會發現會全部自動重啟
`kubectl delete pod wordpress-db-5cgvm`
`kubectl delete pod/wordpress-deployment-1534735485-71kjs`
`kubectl delete pod wordpress-deployment-1534735485-j74hb`
27. `kubectl get pod`，再一次 get pod 就會發現 pod 全部重啟了
28. `kubectl logs wordpress-deployment-1534735485-0wtxq`
29. `kubectl exec wordpress-deployment-1534735485-0wtxq -i -t -- bash`
30. `ls -ahl -R wp-content/uploads/` 會發現檔案都還在
#### Pet Sets
1. Pet Sets 是從 Kubernetes 1.3 之後開始的**新功能**
2. 要執行 **stateful application** 需要：
    - 一個**穩定的 pod hostname**(取代 podname-randomstring)
        - 當一個 pod 有很多 instances，podname 需要有索引(例如：podname-1、podname-2、podname-3)
    - 一個 **stateful app** 需要基於序號數(podname-**x**)或 hostname 的**多個**有 volumes 的 **pods**
        - 目前**刪除**和/或**擴展**一個 **PetSet down**不會刪除跟 PetSet 有關連的 Volume
3. 一個 PetSet 允許 stateful app 使用 **DNS** 找尋其它**同伴**
    - Cassandra clusters、ElasticSearch clusters 使用 **DNS** 來找到其它 cluster 的 members
    - 在 Pet Set 之中**一個**運行中的 **node** 叫做 **一個 Pet** (例如：Cassandra 中的一個 node)
    - 舉例來說： 在 Kubernetes 上使用 Pet Sets 的五個 cassandra nodes，可以命名為 cassandra-1 到 cassandra-5
    - 如果不使用 Pet Sets，可以用取得一個動態 hostname 的方式，而這個方式不能夠使用在設定檔，因為設定檔可以隨時修改名字
4. 一個 PetSet 也允許 stateful app **排序啟動和關閉的 pets**：
    - 取代隨機終止一個 Pet (app 中的一個 instance)，你會知道哪一個會不見
    - 當在可以關閉之前，第一次需要從一個 node **倒出**資料的時候，這很有用
5. 在 PetSets 依然還很多**未來工作**需要完成
#### Daemon Sets
1. Daemon Sets 確保 Kubernetes cluster 的**每一個 node** 運行相同的 pod 資源
    - 如果你想要**確保**特定 pod 運行在每一個 Kubernetes node，這個非常有用
2. 當一個 node **被新增**到 cluster，新的 pod 就會**自動**被啟動
3. 同樣地，當一個 node **被移除**，pod 將不會在其它 node 進行**再排程**
4. 典型的**應用例子**
    - Logging aggregators
    - Monitoring
    - Load Balancers / Reverse Proxies / API Gateways
    - 運行一個 daemon 在每一個 physical instance 只需要一個 instance
#### 監控資源用量
1. Heapster 能夠**監控 Container Cluster** 和**效能分析**
2. 它提供了 Kubernetes 的監控平台
3. 它是必要的，如果想要在 Kubernetes 使用 **pod auto-scaling**
4. Heapster **透過 REST endpoint** 輸出 cluster metrics
5. 可以與 Heapster 使用**不同的後端**
    - 範例會使用 InfluxDB，但是其它像是 Google Cloud Monitoring/Logging 和 Kafka 也是可以的
6. **Visualizations** (圖像) 可以使用 Grafana 表現
    - Kubernetes 儀表板只要 monitoring 啟動就可以顯示圖表
7. 所有的這些技術(Heapster、InfluxDB 和 Grafana)都可以在 pods 裡面啟動
8. **YAML 檔案**可以在 [Heapster 的 github repository](https://github.com/kubernetes/heapster/tree/master/deploy/kube-config/influxdb) 被找到
    - 在下載完 repository 之後，平台可以使用 addon system 或使用 kubectl create -f directory-with-yaml-files/ 來部署
#### Demo：監控資源用量
1. `git clone https://github.com/kubernetes/heapster.git`
    - 後改用 [1.3 版本](https://github.com/kubernetes/heapster/releases)
2. `cd heapster/deploy/kube-config/influxdb`
3. `vim grafana.yaml`
    - 把這行註解掉 `kubernetes.io/cluster-service: 'true'`
4. `vim heapster.yaml`
    - 把這行註解掉 `kubernetes.io/cluster-service: 'true'`
5. `vim influxdb.yaml`
    - 把這行註解掉 `kubernetes.io/cluster-service: 'true'`
6. `cd ..`
7. `kubectl create -f influxdb`
8. `kubectl create -f kubernetes-course/deployment/helloworld.yml`
9. `minikube service monitoring-grafana --namespace=kube-system --url`
10. 進去 Grafana 之後，選擇左列選單，選擇 Sign In，然後就可以選擇 cluster 或是 pod 觀看目前的狀態
#### Autoscaling
1. Kubernetes 可以基於 metrics 來**自動 scale pods**
2. Kubernetes 可以自動 scale 一個 Deployment、Replication Controller 或 ReplicaSet
3. 在 Kubernetes 1.3 版本後，**根據 CPU 用量 scaling** 是可以使用的
    - 有 alpha 的支持，基於 metrics 的 application 是可用的 (像是每秒取得或平均請求延遲)
        - 要啟動這個，cluster 必須要設 env 變數裡面的 ENABLE\_CUSTOM_METRICS 為 true 來啟動
4. Autoscaling 會對目標 pods **定期取得**用量
    - **預設是 30 秒**，可以在啟動 controller-manager 使用 `--horizontal-pod-autoscaler-sync-period` 來修改
5. Autoscaling 會使用監控工具 **heapster** 來收集它們的 metrics 和決定如何 scaling
    - Heapster 必須要在 autoscaling work 之前安裝並運行
6. **例子**
    - 運行一個 **200m** 的 **CPU 資源**請求的 **pod** 並在 **pod** 運行一個 **deployment**
    - 200m = 200 millicpu (或是 200 millicores)
    - 200m = 0.2 也就是運行 node 的 CPU 核心的 20%
        - 如果 node 是雙核心，它還是只有單核心的 20%
    - 可以採用 CPU 用量為 50% 的 autoscaling (也就是 100m)
    - 水平 Pod Autoscaling 可以增加/減少 pods 來維持目標 CPU 用量為 50%(或是 100m/在 pod 裡面一個核心10%)
7. 測試 autoscaling
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hpa-example
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: hpa-example
      spec:
        containers:
        - name: hpa-example
          image: gcr.io/google_containers/hpa-example
          ports:
          - name: http-port
            containerPort: 80
          resources:
            requests:
              cpu: 200m
```
8. autoscaling specification 範例
```
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-example-autoscaler
spec:
  scaleTargetRef:
    apiVersion: extensions/v1beta1
    kind: Deployment
    name: hpa-example
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50
```
#### Demo：Autoscaling
1. `cat autoscaling/hpa-example.yml`
2. `minikube stop`
3. `minikube start --extra-config kubelet.EnableCustomMetrics=true`
4. `kubectl create -f autoscaling/hpa-example.yml`
5. `kubectl get hpa`
6. `kubectl run -i --tty load-generator --image=busybox /bin/sh`
7. `wget http://hpa-example.default.svc.cluster.local:31001`
8. `cat index.html`
9. `rm index.html`
10. `while true; do wget -q -O- http://hpa-example.default.svc.cluster.local:31001; done`
11. `kubectl get pod`，這時候可以看出他會建立很多個
12. `kubectl get hpa` 觀看使用狀態