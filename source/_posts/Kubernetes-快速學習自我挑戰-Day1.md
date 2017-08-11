---
title: Kubernetes 快速學習自我挑戰 Day1
thumbnail:
  - /blogs/images/learning/kubernetes/kubernetesday1.png
date: 2017-08-10 15:02:09
categories: 學習歷程
tags: Kubernetes
---
<img src="/blogs/images/learning/kubernetes/kubernetesday1.png">

***
### Kubernetes 觀念簡介
#### 什麼是 Kubernetes
1. Kubernetes 是一個開源的 **orchestration** system (編排系統)，提供給 Docker containers 做使用
    - 它可以讓你在機器的 cluster 中規劃 **containers**
    - 你可以在一台機器上面跑**很多 containers**
    - 你可以運行 long running **services** (像是網頁應用程式)
    - Kubernetes 會**控管**這些 container 的狀態
        - 可以在特定 nodes 上啟動 container
        - 當 container 被砍的時候，會再重啟一個 container
        - 可以將 containers 從一個 node 移到另外一個 node
2. 跟只有手動運行一些 docker containers 在一個 host 上不同的是，Kubernetes 是一個將會為你管控 container 的平台
3. Kubernetes clusters 可以從一個 node 開始到數千個 nodes
4. 其他有名的 docker orchestrators：
    - Docker Swarm
    - Mesos
##### Kubernetes 的優點
1. 你可以在任何地方運行 **Kubernetes**
    - On-premise (自有資料中心)
    - 公開 (Google cloud, AWS)
    - 混合：公開和私有
2. 高度模組化
3. 開源
4. 非常好的社群
5. Google 支援
#### Container 簡介
1. Docker 是最受歡迎的 container 軟體
    - Docker 的另外一個方案是 rkt，同樣也可以與 Kubernetes 一同運行
2. Dokcer **Engine**
    - The Docker runtime
    - 讓 docker images 運行的軟體
3. Docker Hub
    - 用來儲存和取得 docker images 的線上服務
    - 同樣也允許你線上**建立 docker** images
##### Docker 的優點
1. **獨立**：使用所有的 dependencies 來 ship binary
    - 不需要裕行在自己的機器上，不過不能用在產品化
2. 在 Dev、QA和產品化環境更加**接近**，因為使用同樣的 binary
3. Docker 讓開發團隊可以**更加快速**的 ship
4. 你可以運行完全一樣的 docker image 在筆電、資料中心虛擬機和雲端主機供應商
5. Docker 對作業系統級的分離使用 Linux Containers (一個核心特色) 
#### Kubernetes 設定
1. Kubernetes 應該要可以在**任何地方**運行
2. 但是，對於雲端供應商，像是 AWS 和 GCE，還是有很多**整合**要做
    - 像是 **Volumes** 和 **外部 Load Balances** 只能運行在**被支援**的雲端供應商
3. 會先使用 **minikube** 來快速讓本機單一機器用 Kubernetes cluster 運行起來
4. 接下來會用 **kops** 在 AWS 上把一個 cluster 運行起來
    - kops 是可以被用來運行高可用型的 **產品化 cluster**
5. 使用自己的實驗室是有可能的(而且高度建議)
  - 使用 AWS 免費方案 (給你 t2.micro's 750 小時/月)
      - [https://aws.amazon.com](https://aws.amazon.com)
  - 使用本地機器
      - 使用 [minikube](https://github.com/kubernetes/minikube)
  - 使用 Digital Ocean
#### 使用 minikube 在本地端設定
1. **Minikube** 是一個讓 Kubernetes 在本地端運行變簡單的工具
2. Minikube 運行單一 node Kubernetes cluster 在 Linux VM 裡面
3. 它的目標用戶是那些想要拿來測試或是用它來開發的人
4. 它不能運行在產品化的 cluster，它是一個沒有高可用性的單一 node 機器
5. 它可以運行在 **Windows**、**Linux** 和 **MacOS**
6. 你會需要安裝 **虛擬化軟體** 才能運行 minikube
    - Virtualbox 是免費的且可以[直接下載](https://www.virtualbox.org/)
7. [下載 minikube](https://github.com/kubernetes/minikube)
8. 啟動你的 cluster 只要(在 shell/terminal/powershell)輸入 `minikube start`
#### 安裝 minikube
1. [安裝最新版本的 minikube](https://github.com/kubernetes/minikube/releases)
2. 安裝完成之後，啟動 minikube `minikube start`
3. [安裝 kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
4. `chmod +x kubectl && sudo mv kubectl /usr/local/bin/`
5. `kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080`
6. `kubectl expose development hello-minikube --type=NodePort`
7. `minikube service hello-minikube --url`
8. `minikube stop`
#### Kops 介紹
1. 設置 Kubernetes 在 AWS 上面，可以使用叫做 **kops** 的工具
    - kops 代表 **Kubernetes Operations**
2. 這個工具允許你做產品化等級的 Kubernetes **安裝**、**升級**和**管理**
3. 另外，還有一個叫做 kube-up sh 的**傳統**工具
    - 這是一個用來建立 cluster 的簡易工具，但現在已經停止維護，它不能用來建立一個產品化準備的環境
4. Kops 只能運行在 Mac/Linux
5. 如果你使用 windows，你必須要先啟動虛擬機
6. 可以使用 Vagrant 來快速建立一個 Linux box
7. 下載 [Virtualbox](https://virtualbox.org) 和 [Vagrant](https://vagrantup.com)，兩個都需要
8. 下載完之後，建立一個新的虛擬機，然後直接在 cmd/powershell 新增以下指令
```
mkdir ubuntu
cd ubuntu
vagrant init ubuntu/xenial64
vagrant up
```
#### 準備 Kops 安裝
1. 完成上面的步驟
2. `vagrant ssh-config` 檢視 ssh 狀態
3. `vagrant ssh` 即可登入虛擬機
4. `puttygen putty` 在 windows 上可以使用 putty 來登入
#### 為 Kops 安裝準備 AWS
1. [Kops Github](https://github.com/kubernetes/kops)
2. `brew update && brew install kops`
3. `wget https://github.com/kubernetes/kops/releases/download/1.7.0/kops-linux-amd64`
4. `chmod +x kops-linux-amd64` 新增執行權限
5. `mv kops-linux-amd64 /usr/local/bin/kops` 移動 kops
6. `apt-get update && apt-get install python-pip -y`
7. `pip install awscli`
8. 進入 AWS，選擇服務 IAM (Identity and Access Management)，選擇左列選單 Users，選擇 Add User，命名為 kops，下面選項 Programmatic access 要打勾，下個步驟選擇 AdministratorAccess，完成設定。
9. `aws configure`
10. `ls -ahl ~/.aws/` 檢視 aws credentials
11. 設定完 IAM 之後，回到服務，選擇 S3，新增 bucket，名稱設定為 kops-state-b429b，最後一個是亂數，因為名稱要是唯一的，地區的選擇要去 [cloudping](http://www.cloudping.info/) 看哪個最快，選擇最快的就可以了，接下來直接按到完成。
12. 接下來要設定 DNS，選擇服務 Route53，選擇 DNS management 的 Get Started Now，選擇 Create Hosted Zone，打入自己所擁有的網域，名稱設為 kubernetes，最後到自己的 Domain 主機商那邊設定 DNS。
#### 使用 kops 進行 AWS Cluster 設定
1. [安裝 kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
2. ` curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl` 下載最新版的 kubectl
3. `chmod +x ./kubectl`
4. `sudo mv ./kubectl /usr/local/bin/kubectl`
5. `ssh-keygen -f .ssh/id_rsa` 新增 ssh-key
6. `kops create cluster --name=kubernetes.appsoliloquy.com --state=s3://kops-state-b429d --zones=ap-northeast-1a --node-count=2 --node-size=t2.micro --master-size=t2.micro --dns-zone=kubernetes.appsoliloquy.com`
7. `kops update cluster kubernetes.appsoliloquy.com --yes --state=s3://kops-state-b429d`
8. `cat .kube/config`
9. `kubectl get node`
10. `kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080`
11. `kubectl expose deployment hello-minikube --type=NodePort`
12. `kubectl get service`，檢查 port
13. 開啟 Services 的 VPC，點選 Security Groups，點選 master.<自己的 domain>，點選 Inbound Rules，新增 Custom TCP rule，將剛剛取得的 port 貼上、source 設定為 0.0.0.0。
14. 進去 api.kubernetes.<自己的 domain>：剛剛的 port，就可以看到內容了