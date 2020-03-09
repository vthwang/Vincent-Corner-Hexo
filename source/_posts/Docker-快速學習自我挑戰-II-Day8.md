---
title: Docker 快速學習自我挑戰 II Day8
thumbnail:
  - /images/learning/docker-2/DockerDay08.png
date: 2020-03-06 16:53:37
categories: 學習歷程
tags: Kubernetes
---
<img src="/images/learning/docker-2/DockerDay08.png">

***
### Service 簡介和演示
1. 不要直接使用和管理 Pods，為什麼？
    - 當我們使用 <span style="color:red">**ReplicaSet**</span> 或 <span style="color:red">**ReplicaController**</span> 做水平擴展 Scale 的時候，Pods 有可能會被 Terminated
    - 當我們使用 <span style="color:red">**Deployment**</span> 的時候，我們去更新 Docker Image Version，舊的 Pods 會被 Terminated，新的 Pods 會被創建
2. 創建 Service
    - `kubectl expose` 命令，會給我們的 pod 創建一個 Service，供外部訪問
    - Service 主要有三種類型，一種叫 **Cluster ip**(只供 Cluster 內部訪問)，一種叫 **NodePort**，一種叫外部的 **Loadbalancer**
    - 另外也可以使用 **DNS**，但是 DNS 要 add-on
3. 接續上次的 Pods，先讓 nginx 可以被外部訪問
`kubectl expose pods nginx-pod`
4. 使用 `kubectl get svc` 會看到 nginx-pod 的 ip 10.104.59.208
5. 進去 minikube 的裡面，`curl 10.104.59.208`，會回傳 nginx 服務
6. 新增 deployment_python_http.yml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-test
spec:
  replicas: 2
  selector:
    matchLabels:
      app: service_test_pod
  template:
    metadata:
      labels:
        app: service_test_pod
    spec:
      containers:
        - name: simple-http
          image: python:2.7
          imagePullPolicy: IfNotPresent
          command: ["/bin/bash"]
          args: ["-c", "echo \"<p>Hello from $(hostname)</p>\" > index.html; python -m SimpleHTTPServer 8080"]
          ports:
          - name: http
            containerPort: 8080
```
7. 先進去機器 `minikube ssh` 把 python Image 先 pull 下來
`docker pull python:2.7`
8. 新增 Deployment
`kubectl create -f deployment_python_http.yml`
9. 進去 minikube 裡面 `minikube ssh`，分別對兩個 Pods 的 ip 執行 curl，就會回傳不同的 hostname
`curl 172.17.0.6:8080`
`curl 172.17.0.7:8080`
10. 使用 `kubectl get deployment` 查看 deployment 名稱，並對外開放
`kubectl expose deployment service-test`
11. 使用 `kubectl get svc` 會發現新增了一個 service-test，對 service-test 多次執行 curl，會發現每次返回的 hostname 都不一定一樣，也就是說，service 會自動做負載均衡
`curl 10.99.229.174:8080`
12. 我們要做不停機更新，先在 minikube 裡面不停的 curl
`while true; do curl 10.99.229.174:8080;done`
13. 用編輯的方式進行更新，使用以下指令會跳出 Deployment 的 yml 檔案，修改 args 為 new version of helloworld，並儲存
`kubectl edit deployment service-test`
14. 使用 `kubectl get pods` 就會看到之前兩個 Pods Terminated，而且啟動了兩個新的 Pods，但是更新過程中，還是有幾秒鐘的版本穿插的問題，因為沒有使用 Rolling Update，詳細可參考 [Rolling Update 文檔](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
### NodePort 的 Service 以及 Label 的簡單實用
1. 首先清理環境，把所有 Services 和 Pods 都刪除
2. 在 K8s 裡面，幾乎所有的資源都可以設置 label，label 的形式是一對 key 和 value 組成，label 不只可以設置一個
3. 先使用之前的 pod_nginx.yml 創建資源
`kubectl create -f pod_nginx.yml`
4. 將端口開放，類型設置為 NodePort
`kubectl expose pods nginx-pod --type=NodePort`
5. 使用 `kubectl get svc` 顯示 Service 的端口，再用 `kubectl get node -o wide` 顯示出 minikube 的 ip 地址，直接在本地瀏覽器輸入 http://192.168.99.101:32394/ 就可以訪問 nginx 服務了
6. 先刪除 NodePort 的 Service
`kubectl delete service nginx-pod`
7. 可以自己手動新增 Service，首先新增一個 service_nginx.yml，target port 的設置可以使用 `cat pod_nginx.yml` 打開之前新增 pod 的 yml，裡面就有定義 ports name 是 nginx port，這邊的 selector 就是創建資源的 label，可以使用 `kubectl get pods --show-labels` 查看 labels
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  ports:
  - port: 32333
    nodePort: 32333
    targetPort: nginx-port
    protocol: TCP
  selector:
    app: nginx
  type: NodePort 
```
8. 使用 `kubectl create -f service_nginx.yml` 新增 Service，並使用 `kubectl get svc` 查看服務確實啟動，到本地瀏覽器輸入 http://192.168.99.101:33333/ 就可以訪問 nginx 服務了
9. 新增 pod_busybox.yml
```
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
spec:
  nodeSelector:
    hardware: good
  containers:
  - name: busybox-container
    image: busybox
    command:
      - sleep
      - "360000"
```
10. 使用 `kubectl create -f pod_busybox.yml` 創建 Pod，但是當用 `kubectl get pods` 查看，會看到這個 Pod 顯示 Pending，使用 `kubectl get node --show-labels` 查看 node 標籤會發現沒有 hardware:good 的標籤，所以才顯示 Pending
11. 給 minikube 加上 label
`kubectl label node minikube hardware=good`
12. 再使用 `kubectl get pods` 查看就會發現 busybox 的 pod 啟動了
13. 總結：ClusterIP 只能是內部訪問，所以它不能提供服務，我們可以透過 NodePort 去提供服務，但是會有幾個問題，(1) NodePort 的範圍只能是 30000-32767，(2) Expose 會在所有節點上提供給外部訪問，所以 NodePort 在實際的 Production 環境也不怎麼使用，但是可以用，在 Production 環境大家用的比較多的就是 Loadbalancer 或是 ExternalName，Loadbalancer 需要結合雲服務商去使用，ExternalName 就是使用 DNS 服務
### kubectl 指令補全
1. `kubectl completion zsh`
2. 更新 zsh
`source <(kubectl completion zsh)`
### 使用 Kops 在 DigitalOcean 上面搭建 K8s 集群
1. [Kops Github Page](https://github.com/kubernetes/kops/)：Kops 是用於 Production 級別的 K8s 安裝、升級和管理
2. 註冊一個域名，把以下三個 NameServer 指向 DigitalOcean
    - ns1.digitalocean.com
    - ns2.digitalocean.com
    - ns3.digitalocean.com
3. 進入 DigitalOcean API 介面，申請一個 Personal access tokens 和一個 Spaces access keys
4. 在畫面右上角點擊 Create Space，新增一個空間，這邊的空間名是全網唯一的
5. 使用 dig 指令查看域名狀態，如果都有回傳內容，代表網域生效
    - `dig +short pcelab.info ns`
    - `dig +short pcelab.info soa`
6. 參考 [DigitalOcean 文件](https://github.com/kubernetes/kops/blob/master/docs/getting_started/digitalocean.md)創建 Cluster
7. 設定參數
```
export KOPS_STATE_STORE=do://<bucket-name>
export DIGITALOCEAN_ACCESS_TOKEN=<access-token>

export S3_ENDPOINT=sgp1.digitaloceanspaces.com
export S3_ACCESS_KEY_ID=<access-key-id>
export S3_SECRET_ACCESS_KEY=<secret-key>

export KOPS_FEATURE_FLAGS="AlphaAllowDO"
```
8. 使用 kops 新增 Cluster 和 Master 節點
`kops create cluster --cloud=digitalocean --name=kops.pcelab.info --image=ubuntu-18-04-x64 --networking=weave --zones=sgp1 --ssh-public-key=~/.ssh/id_rsa.pub --node-size=s-1vcpu-1gb`
9. 驗證 Cluster
`kops validate cluster`
10. 查看 Node 是否生成
`kubectl get nodes --show-labels`
11. 進入 master 去做操作
`ssh -i ~/.ssh/id_rsa admin@api.kops.pcelab.info`
### 容器的基本監控
1. 使用 `docker ps` 查看 Container，再使用 `docker top [Container id]` 就可以查看 Container 的進程，有點類似 Linux 內建的 top 功能
2. `docker stats` 可以實時打印出後台正在運行的 Container 的系統佔用狀態，包含佔了多少內存，多少 CPU，使用 ctrl + C 可以退出
3. 在虛擬機上面安裝 Weave Scope，並修改權限
`sudo curl -L git.io/scope -o /usr/local/bin/scope`
`sudo chmod a+x /usr/local/bin/scope`
4. 啟動 Weave Scope
`scope launch 192.168.205.10`
5. 啟動後的畫面如下圖，進去可以去做一些操作

<img src="/images/learning/docker-2/DockerDay08-Image01.png">

6. 也可以同時監控兩台機器，需要在兩台機器上面都輸入以下命令
`scope launch [機器 1 IP] [機器 2 IP]`
### Gitlab CI 安裝
1. 設置一台 Ubuntu 的主機，安裝過程可以參考 [Gitlab CI Runner 文檔](https://docs.gitlab.com/runner/install/linux-repository.html)
2. 安裝 Docker
`curl -sSL https://get.docker.com | sh`
3. 安裝 Gitlab CI Runner
```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash 
sudo apt-get install gitlab-ci-multi-runner -y
```
4. 查看是否正常運行
`sudo gitlab-ci-multi-runner status`
5. 設置 Docker 權限
```
sudo usermod -aG docker gitlab-runner
sudo service docker restart
sudo gitlab-ci-multi-runner restart
```
6. 完成之後，註冊 gitlab-runner
`sudo gitlab-ci-multi-runner register`
### 在 Hexo 使用 Gitlab CI
1. 


