---
title: Docker 快速學習自我挑戰 II Day7
thumbnail:
  - /images/learning/docker-2/DockerDay07.jpg
date: 2020-03-04 14:27:55
categories: Study Note
tags:
  - Docker
  - Kubernetes
toc: true
---
<img src="/images/learning/docker-2/DockerDay07.jpg">

***
### Docker Cloud
1. Docker Cloud 提供容器管理，編排，部署的托管服務
2. Docker Cloud 的模塊
    - 關聯雲服務 AWS、Azure
    - 添加節點作為 Docker Host
    - 創建服務 Service
    - 創建 Stack
    - Image 管理
3. Docker Cloud 兩種運行模式
    - Standard 模式：一個 Node 就是一個 Docker Host
    - Swarm 模式：多個 Node 組成的 Swarm Cluster
### Docker Cloud 自動 Build Docker Image
1. 在 [Docker Hub](https://hub.docker.com/) 新增一個 Repository 並關聯到 Github 帳戶，並綁定 Repository
2. 在 Build 頁面選擇要 build 的 Repository，其餘設定如下圖，最後選擇 Save and Build

<img src="/images/learning/docker-2/DockerDay07-Image01.png">

3. 儲存之後，Docker Cloud 會自動 build，這時候可以修改 Repository 內容和新增 Release，這些操作都會觸發 Docker Cloud 自動 build 的流程，如此一來就實現 Docker Autobuild 的功能
### Docker Cloud 的 CI & CD
1. 把 Repository 下載下來之後，進行修改，並 push 到 Github 之後，再 pull request，系統會自動進行測試，測試完成之後，就可以進行 merge request(合併分支的人就可以參考測試的結果，選擇是否合併分支)，最後 Docker Cloud 會自動 build 並發佈到網站上，這樣就是一整套 CI & CD
### Docker 企業版本地安裝
1. 進入 [Docker EE](https://hub.docker.com/search?q=&type=edition&offering=enterprise)，找尋對應作業系統的頁面
2. 我要安裝 Ubuntu 版本的，進去[試用一個月填寫相關資料](https://hub.docker.com/editions/enterprise/docker-ee-server-ubuntu/trial)
3. 使用 Vagrantfile 安裝虛擬機，因為 Docker EE 需要至少 4G 記憶體，所以記憶體設定為 4GB
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.0"

boxes = [
    {
        :name => "docker-ee-manager",
        :eth1 => "192.168.205.50",
        :mem => "4096",
        :cpu => "1"
    },
    {
        :name => "docker-ee-worker",
        :eth1 => "192.168.205.60",
        :mem => "4096",
        :cpu => "1"
    }

]

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/bionic64"
  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name]
      config.vm.provider "vmware_fusion" do |v|
        v.vmx["memsize"] = opts[:mem]
        v.vmx["numvcpus"] = opts[:cpu]
      end
      config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
      end
      config.vm.network :private_network, ip: opts[:eth1]
    end
  end
end
```
4. 按照[文檔](https://docs.docker.com/ee/docker-ee/ubuntu/)開始安裝
5. 移除舊版本 Docker，因為沒有安裝，會顯示 Unable to locate
`sudo apt-get remove docker docker-engine docker-ce docker-ce-cli docker.io`
6. 在 Manager 和 Worker 更新套件並安裝套件
```
$ sudo apt-get update
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```
7. 在 Manager 和 Worker 設置 Repository - 設置 Docker EE URL，這個 URL 會在申請一個月試用的頁面右下角取得
`DOCKER_EE_URL="<DOCKER-EE-URL>"`
8. 在 Manager 和 Worker 設置 Docker EE 版本
`DOCKER_EE_VERSION=19.03`
9. 在 Manager 和 Worker 添加官方的 GPG key
`curl -fsSL "${DOCKER_EE_URL}/ubuntu/gpg" | sudo apt-key add -`
10. 在 Manager 和 Worker 驗證 Key 的指紋為 `DD91 1E99 5A64 A202 E859 07D6 BC14 F10B 6D08 5F96`
`sudo apt-key fingerprint 6D085F96`
11. 在 Manager 和 Worker 設置 Repository
```
sudo add-apt-repository \
   "deb [arch=$(dpkg --print-architecture)] $DOCKER_EE_URL/ubuntu \
   $(lsb_release -cs) \
   stable-$DOCKER_EE_VERSION"
```
12. 在 Manager 和 Worker 安裝 Docker Engine
```
sudo apt-get update
sudo apt-get install docker-ee docker-ee-cli containerd.io
apt-cache madison docker-ee
```
13. 在 Manager 和 Worker 查看 Docker 版本
`sudo docker version`
14. 只在 Manager 節點安裝 UCP(Universal Control Plane)，需要設置後台帳號密碼
```
docker container run --rm -it --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:3.2.5 install \
  --host-address <node-ip-address> \
  --interactive
  --pod-cidr 10.0.0.0/16
```
15. 安裝完成之後進入 UCP 介面(https://192.168.205.50:443)，登入並上傳 License，接下來到 Node 區塊，選擇添加 node，裡面會有一串 docker-swarm 的命令，直接貼到 Worker 節點就完成連接了
16. 最後，還可以安裝 DTR (Docker Trusted Registry)，在 UCP 左上角的介面點擊 Admin > Admin Setting > Docker Trusted Registry，在裡面可以選擇安裝的節點，並設置外部 ip 及把 Disable TLS Verification 打勾，就會取得指令，直接進入 Workder 節點安裝

<img src="/images/learning/docker-2/DockerDay07-Image02.png">

### Kubernetes
1. 在 Kubernetes，Manager 稱之為 Master 節點，Worker 稱為 Node 節點，Master 節點對外會提供一些接口

<img src="/images/learning/docker-2/DockerDay07-Image03.png">

2. Master 節點有一個 API Server，會向外開放接口，透過 API 可以訪問 Service，Scheduler 是一個調度模塊，會控制 Container 服務要放在哪個節點，Controller 是一個控制，Container 可以做擴展和負載均衡，假設設定 Replica=2，那麼 Controller 就會維持有兩個 Container 在運行，etcd 就是一個分佈式的儲存，主要儲存整個 K8s 的狀態和配置

<img src="/images/learning/docker-2/DockerDay07-Image04.png">

3. Pod 就是 Container 調度裡面的最小單位，一個 pod 就是具有相同 Namespace 的 Container 組合，Namespace 可以有 User Namespace 或是 Network Namespace，但是主要是以 Network Namespace 組合為主，Docker 是創建 Pod 所使用的 Container 技術，Kubelet 會做創建 Container、Network 和 Volume 的管理，kube-proxy 用來做端口的代理和轉發，還有服務發現和負載均衡都是透過 kube-proxy 來實現的，Fluentd 主要是做日誌的採集、儲存和查詢，同時，它還有其他插件，比方說 DNS 模塊，提供 DNS 服務，UI 就是儀表板介面，可以透過網頁的方式去查看整個 K8s 的集群，還有最重要的 Image Registry，主要會從上面去拉取 Docker 的 Image

<img src="/images/learning/docker-2/DockerDay07-Image05.png">

4. 安裝 K8s
    - 單節點的 K8s - [minikube](https://github.com/kubernetes/minikube)
    - 多節點的 K8s - [kubeadm](https://github.com/kubernetes/kubeadm)
    - 雲端版的 K8s - [kops](https://github.com/kubernetes/kops)
    - 企業版的 k8s - [tectonic](https://coreos.com/tectonic/) - 如果節點少於 10 個是免費的
    - k8s 的雲端實驗室 - [Play with Kubernetes](https://labs.play-with-k8s.com/)
5. 先安裝 k8s 命令行，按照[安裝文件](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos)操作
`brew install kubectl`
6. 使用 `kubectl version --client` 測試 cubectl 是否安裝完成
7. 使用 `minikube start --vm-driver=virtualbox --registry-mirror=https://registry.docker-cn.com --image-mirror-country=cn --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers` 創建一個單節點的 k8s Cluster
8. 使用 `kubectl config view` 查看 minikube 創建的組態
9. 使用 `kubectl config get-contexts` 查看 context，在本地可以用不同的 cubectl context 連接不同的 Cluster
10. 使用 `kubectl cluster-info` 查看 Cluster 的狀態
11. 使用 `minikube ssh` 可以進入用 minikube 創建的虛擬機器裡面
### K8s 最小調度單位 Pod
1. 我們不對 Container 做直接操作，因為 Pod 已經是最小單位了，一個 pod 裡面可以包含一個或多個 Container，一個 Pod 會共享一個 Namespace，假設在一個 pod 裡面啟動了兩個 Container，這個概念就像在本地啟動了兩個進程，Container 的通信可以直接透過 localhost

<img src="/images/learning/docker-2/DockerDay07-Image06.png">

2. 新增一個 pod_nginx.yml
```
// 指定版本
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
// 定義的 Container
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
```
3. 使用 `kubectl create -f pod_nginx.yml` 新增 pod，使用 `kubectl delete -f pod_nginx.yml` 刪除 pod
4. 使用 `kubectl get pods` 查看 pod 狀態，會看到有一個 nginx 的 pod 在運行
5. 使用 `kubectl get pods -o wide` 查看更詳細的資訊，會有 ip 和 Node
6. 使用 `minikube ssh` 就可以進去虛擬機器裡面，再用 `docker ps` 就可以看到裡面運行的 Contaienr
7. 使用 `docker network ls` 查看網路，並查看 brige 網路 `docker network inspect [Network id]`，就可以看到 nginx Container 的 ip 為 172.17.0.4
8. 使用 `kubectl get pods -o wide` 會發現 ip 也是 172.17.0.4
9. 也可以直接使用 `kubectl exec -it nginx sh` 進入到 Container 裡面，但是如果 pod 裡面有兩個 Container 以上，它預設會進入第一個 Container，指令裡面有一個 -c 可以指定進去哪個 Container
10. 使用 `kubectl describe pods nginx` 也可以查看 nginx pod 的詳細資訊，包含 ip 地址、Container、Namespace 和端口號等等
11. 先進去 minikube 裡面 `minikube ssh` 使用 `ping 172.17.0.4` 是可以連通的，使用 `curl 172.17.0.4` 也會回傳 nginx 的網頁
12. 在 minikube 裡面 `ip a` 查詢到 ip 為 192.168.99.101，在本地機器 `ping 192.168.99.101` 也會連通，使用 `kubectl port-forward nginx 8080:80` 將 nginx 的服務對外開放，在本地就可以用 http://127.0.0.1:8080/ 連通網站
### ReplicaSet 和 ReplicaController
1. 使用指令刪除 nginx pod
`kubectl delete -f pod_nginx.yml`
2. 新增 rc_nginx.yml，我們在這個 yml 文件定義了 ReplicaSet
```
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```
3. 使用 rc_nginx.yml 啟動 pod
`kubectl create -f rc_nginx.yml`
4. 使用 `kubectl get pods` 查看 pod 狀態，並刪除其中一個 Container `kubectl delete pods [Container id]`，再使用 `kubectl get pods` 會看到 Cluster 自動會再啟動一個 Container
5. 可以透過 scale 的方式增加或減少 pods，並用 `kubectl get pods` 查看 pod 狀態
    - 減少 `kubectl scale rc nginx --replicas=2`
    - 增加 `kubectl scale rc nginx --replicas=4`
6. 使用 `kubectl get pods -o wide` 查看網路狀態，在 Docker Swarm 的時候，使用 vip 解決 Container 通信問題，pods 的通信在後面說
7. 使用 `kubectl delete -f rc_nginx.yml` 刪除 ReplicaController 的 pod
8. 根據 [Kubernetes ReplicaSet 文檔](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)，ReplicaSet 是用來維持 pod 數量的
9. 新增 rs_nginx.yml，我們在這個 yml 文件定義了 ReplicaSet
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx
  labels:
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      name: nginx
      labels:
        tier: frontend
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```
10. 使用 `kubectl create -f rs_nginx.yml` 新增 pod
11. Scale ReplicaSet
`kubectl scale rs nginx --replicas=2`
### Deployment
1. 根據 [Kubernetes Deployment 文檔](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)，Deployment 為 Pods 和 ReplicaSet 提供聲明更新，如果用 Deployment 創建的 replicas，是不能個別操作或使用 delete 刪除的，一定要對 Deployment 進行操作
2. 新增 deployment_nginx.yml，定義類型為 Deployment
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.12.2
        ports:
        - containerPort: 80
```
3. 透過指令創建 deployment
`kubectl create -f deployment_nginx.yml`
4. 使用 `kubectl get deployment` 查看 Deployment 啟動的狀態，使用 `kubectl get rs` 查看 ReplicaSet 的狀態，會發現 Deployment 會自動創建 REplicaSet，使用 `kubectl get deployment -o wide` 顯示更多資訊
5. 升級 Deployment
`kubectl set image deployment nginx-deployment nginx=nginx:1.13`
6. 使用 `kubectl get deployment -o wide` 查看會發現 nginx 已升級為 1.13
7. 使用 `kubectl get rs` 查看 ReplicaSet 會發現會新增一個新的 ReplicaSet，且停用舊的 ReplicaSet，
8. 使用指令查看升級的版本
`kubectl rollout history deployment nginx-deployment`
9. 使用 undo 指令回到上一個版本
`kubectl rollout undo deployment nginx-deployment`
10. 使用升級指令回到最新版本
`kubectl set image deployment nginx-deployment nginx=nginx:1.13`
11. Deployment 提供一個方法可以將端口向外開放
`kubectl expose deployment nginx-deployment --type=NodePort`
12. 實際上，它是創建了一個 Service，使用 `kubectl get svc` 查看 Service，會看到它 expose 32141 端口，那麼通過 `curl 192.168.99.101:32141` 就可以訪問 nginx 了
### 本地設定多 Cluster K8s 
1. [K8s 設定多 Cluster 文檔](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
### K8s 基礎網路 Network
1. 新增 pod_busybox.yml
```
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
spec:
  containers:
  - name: busybox-container
    image: busybox
    command:
      - sleep
      - "360000"
```
2. 新增 pod_nginx.yml
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx-container
    image: nginx
    ports:
    - name: nginx-port
      containerPort: 80
```
3. 把這兩個 pods 啟動
`kubectl create -f pod_busybox.yml`
`kubectl create -f pod_nginx.yml`
4. 查看兩個 pods 的狀態
`kubectl get pods -o wide`
5. 進去 busybox 的 Shell 裡面
`kubectl exec -it busybox-pod sh`
6. Ping 另外一個 pod 是可以通的
`ping 172.17.0.8`
7. 關於 Cluster 跨機器的網路通信可以參考 [Kubernetes Network 文檔](https://kubernetes.io/docs/concepts/cluster-administration/networking/)，Kubernetes 對網路有以下三點基本要求
    - 所有的 Container 都可以互相溝通，而且不需要 NAT
    - 所有的 Node 都可以跟所有的 Container 互相溝通，而且不需要 NAT(反之亦然)
    - Container 看到自己的 ip 是什麼，其他人看到它也要是相同的 ip