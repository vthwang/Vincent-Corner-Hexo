---
title: Docker 快速學習自我挑戰 II Day1
thumbnail:
  - /images/learning/docker-2/DockerDay01.png
date: 2019-05-17 18:06:24
categories: Study Note
tags: Docker
---
<img src="/images/learning/docker-2/DockerDay01.png">

***
### 課前準備及目標
&emsp;&emsp;因為新的專案要使用 CI 和 CD，研究之後，發現應該要先學 Docker，最後的目標希望能在專案實現自動化的部署。預計使用工具為 Drone 和 Gogs 來實現 Laravel 專案的自動部署。最終的目標，當然是希望透過 Docker 讓 DevOps 更有系統性，拋開以往的手動化操作可能發生的錯誤，讓程式碼發佈更為嚴謹且穩定。
### Docker 簡介
1. Docker 比起虛擬機更加輕巧，不需要虛擬化技術。
2. Docker 的好處
    - 簡化配置
    - 程式碼流水線管理
    - 提高開發效率
    - 隔離應用
    - 整合伺服器
    - 調試能力
    - 多用戶
    - 快速部署
3. 容器需要知道的兩樣工具：Docker 和 Kubernetes (k8s)
4. Kubernetes 是容器編排工具，對容器創建、管理、調度、運維
5. DevOps = 文化 + 過程 + 工具
### 容器技術概述
#### 虛擬化的優點
1. 資源池：物理機器的資源分配到不同的虛擬機器裡面
2. 很容易擴展：加物理機器或是虛擬機器
3. 很容易雲化：亞馬遜 AWS，阿里雲...等
#### 虛擬化的侷限性
1. 每一個虛擬機都是一個完整的操作系統，要分配資源給它。當虛擬機的數量增多時，操作系統消耗的資源會變多。
#### 容器解決的問題
1. 解決了開發和運維之間的矛盾
2. 在開發和運維之間建立了一個橋樑，實現 DevOps 的最佳解決方案
#### 容器是什麼？
1. 軟體和依賴套件的標準化打包
2. 應用之間的隔離
3. 共享同一個 OS Kernal
4. 可以運行在很多主流的作業系統上
#### 容器和虛擬機的區別
1. 容器是 APP 層面的隔離、虛擬化是物理資源層面的隔離
2. 虛擬機和容器可以合在一起，可以在虛擬機器裡面創建容器，這是沒有衝突的。
### 環境部署
#### 使用 VirtualBox + Vagrant
1. 為什麼不用 VMware? 因為 VMware 本身要錢，而且 Vagrant 搭配 VMware 也是要額外收錢的。
2. 安裝 [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 當作虛擬化工具
3. 安裝 [Vagrant](https://www.vagrantup.com/)
4. 新增目錄 Ubuntu
`mkdir Ubuntu`
5. 初始化 Vagrant 檔案 (可以在 [Vagrant 官網找到需要的映像檔](https://app.vagrantup.com/boxes/search))
`vagrant init ubuntu/xenial64`
6. 啟動虛擬機
`vagrant up`
7. 檢查虛擬機狀態
`vagrant status`
8. 停止虛擬機
`vagrant halt`
9. 刪除虛擬機
`vagrant destroy`
10. 連線到虛擬機
`vagrant ssh`
#### Ubuntu 上安裝 Docker
1. [Ubuntu 上安裝 Docker 文檔](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
2. 如果有舊版的 Docker 透過以下指令移除
`sudo apt-get remove docker docker-engine docker.io containerd runc`
3. 更新套件
`sudo apt-get update`
4. 安裝 Docker 所需套件
```
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```
5. 新增 Docker 金鑰
`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
6. 確認金鑰
`sudo apt-key fingerprint 0EBFCD88`
7. 綁定遠端 Docker Repository
```
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
8. 安裝最新版本的 Docker CE
`sudo apt-get install docker-ce docker-ce-cli containerd.io`
9. 確定 Docker 安裝完成
`sudo docker run hello-world`
10. 檢查 Docker 版本
`sudo docker version`









