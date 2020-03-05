---
title: Docker 快速學習自我挑戰 II Day7
thumbnail:
  - /images/learning/docker-2/DockerDay07.jpg
date: 2020-03-04 14:27:55
categories: 學習歷程
tags: Docker
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
3. 使用 Vagrantfile 安裝虛擬機，因為 Docker EE 需要更多資源，所以記憶體設定為 3GB
```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.0"

boxes = [
    {
        :name => "docker-ee-manager",
        :eth1 => "192.168.205.50",
        :mem => "3072",
        :cpu => "1"
    },
    {
        :name => "docker-ee-worker",
        :eth1 => "192.168.205.60",
        :mem => "3072",
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
5. 移除舊版本 Docker，因為沒有安裝，會顯示 No Match
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
sudo apt-get install docker-ee=<VERSION_STRING> docker-ee-cli=<VERSION_STRING> containerd.io
sudo docker run hello-world
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
```
15. 安裝完成之後進入 UCP 介面，登入並上傳 License，接下來到 Node 區塊，選擇添加 node，裡面會有一串 docker-swarm 的命令，直接貼到 Worker 節點就完成連接了
16. 最後，還可以安裝 DTR (Docker Trusted Registry)，在 UCP 左上角的介面點擊 Admin > Admin Setting > Docker Trusted Registry，在裡面可以選擇安裝的節點，並設置外部 ip 及把 Disable TLS Verification 打勾，就會取得指令，直接進入 Workder 節點安裝
### Kubernetes
1. 在 Kubernetes，Manager 稱之為 Master 節點，Worker 稱為 Node 節點，Master 節點對外會提供一些接口

<img src="/images/learning/docker-2/DockerDay07-Image02.png">

2. Master 節點有一個 API Server，會向外開放接口，透過 API 可以訪問 Service，Scheduler 是一個調度模塊，會控制 Container 服務要放在哪個節點，Controller 是一個控制，Container 可以做擴展和負載均衡，假設設定 Replica=2，那麼 Controller 就會維持有兩個 Container 在運行，etcd 就是一個分佈式的儲存，主要儲存整個 K8s 的狀態和配置

<img src="/images/learning/docker-2/DockerDay07-Image03.png">

3. Pod 就是 Container 調度裡面的最小單位，一個 pod 就是具有相同 Namespace 的 Container 組合，Namespace 可以有 User Namespace 或是 Network Namespace，但是主要是以 Network Namespace 組合為主，Docker 是創建 Pod 所使用的 Container 技術，Kubelet 會做創建 Container、Network 和 Volume 的管理，kube-proxy 用來做端口的代理和轉發，還有服務發現和負載均衡都是透過 kube-proxy 來實現的，Fluentd 主要是做日誌的採集、儲存和查詢，同時，它還有其他插件，比方說 DNS 模塊，提供 DNS 服務，UI 就是儀表板介面，可以透過網頁的方式去查看整個 K8s 的集群，還有最重要的 Image Registry，主要會從上面去拉取 Docker 的 Image

<img src="/images/learning/docker-2/DockerDay07-Image04.png">

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
8. 使用 `cubectl config view` 查看 minikube 創建的組態
9. 使用 `cubectl config get-contexts` 查看 context，在本地可以用不同的 cubectl context 連接不同的 Cluster
10. 使用 `cubectl clusterinfo` 查看 Cluster 的狀態
11. 使用 `minikube ssh` 可以進入用 minikube 創建的虛擬機器裡面
### K8s 最小調度單位 Pod
1. 我們不對 Container 做直接操作，因為 Pod 已經是最小單位了，一個 pod 裡面可以包含一個或多個 Container，一個 Pod 會共享一個 Namespace，假設在一個 pod 裡面啟動了兩個 Container，這個概念就像在本地啟動了兩個進程，Container 的通信可以直接透過 localhost

<img src="/images/learning/docker-2/DockerDay07-Image05.png">

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