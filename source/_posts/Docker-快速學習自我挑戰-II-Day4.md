---
title: Docker 快速學習自我挑戰 II Day4
thumbnail:
  - /images/learning/docker-2/DockerDay04.jpg
date: 2020-02-28 15:09:54
categories: 學習歷程
tags: Docker
---
<img src="/images/learning/docker-2/DockerDay04.jpg">

***
### Docker 網路簡介
1. Docker 網路
    - 單機：Bridge Network / Host Network / None Network
    - 多機：Overlay Network
2. 用 Vagrant 開啟兩台機器，新增 Vagrantfile
### 網路基本概念
1. 如果要跟 Web 服務器通訊，流程是，打開瀏覽器，取得服務器內容，這個過程使用的是 HTTP 協議。
2. 傳輸網站數據，就需要理解網路的分層，TCP/IP 協議如下圖，傳輸層(Transport Layer)裡面，TCP 協議是可靠的協議，而 UDP 協議是不可靠的，而 HTTP 協議就屬於應用層(Application Layer)，主要是用來傳輸數據的。

<img src="/images/learning/docker-2/DockerDay04-Image01.jpg">

3. 路由基本就像是交通一樣，他會選一條路徑進行資料傳輸。
4. Public IP 和 Private IP
    - Public IP：全球資訊網裡的唯一標示，可以訪問。
    - Private IP：不可以在全球資訊網裡面使用，僅供內部企業使用。
5. 網路轉換地址 NAT：NAT 會記住內部地址和端口號，並轉換成外部地址和端口號才將數據傳送到全球資訊網，然後在全球資訊網的查詢結果，會返回到 NAT，NAT 會再將外部地址和端口號轉換回內部地址和端口號，並將數據回傳給該電腦。
6. Ping 和 Telnet
    - ping：ping 使用的是 ICMP 協議，可以驗證 IP 的可達性，但是如果沒有回應，並不一定是該 ip 的機器沒有啟動，有可能機器有防火牆或是其他路由器的原因。
    - telnet：檢查服務的可用性。
7. 安裝 [Wireshark](https://www.wireshark.org/)，可以查看網路數據包。
### Linux 網路命名空間
1. 進入 node1 執行以下命令
`docker run -d --name=test1 busybox /bin/sh -c "while true; do sleep 3600; done"`
2. 進入 busybox
`docker exec -it test1 /bin/sh`
3. 在 busybox 裡面執行 `ip a`，會看到容器有自己的 ip
4. 新增一個新容器
`docker run -d --name=test2 busybox /bin/sh -c "while true; do sleep 3600; done"`
5. 執行 `docker exec test2 ip a`，就會發現容器 test2 有自己的 ip，而且 test1 和 test2 可以互相 ping 通的。
#### Linux Namespace 實作
1. 查看 Namespace 列表
`sudo ip netns list`
2. 刪除 Namespace
`sudo ip netns delete test1`
3. 新增 Namespace
`sudo ip netns add test1`
4. 查看 Namespace ip，查看之後會發現，(1) 它沒有 ip 地址。(2) 它的狀態是 DOWN 的，沒有運行起來。
`sudo ip netns exec test1 ip a`
5. 把 test1 啟動
`sudo ip netns exec test1 ip link set dev lo up`
6. 透過以下指令查看會發現 mode 變成 unknown，因為只有單一端口是沒有辦法啟動的
`sudo ip netns exec test1 ip link`
7. 新增一個可以連線的虛擬連線與端口
`sudo ip link add veth-test1 type veth peer name veth-test2`
8. 透過 `ip link` 查看端口就會發現新增了兩個端口，但是狀態都是 DOWN 且沒有 ip 地址
```
9: veth-test2@veth-test1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 6e:4f:90:eb:c8:a8 brd ff:ff:ff:ff:ff:ff
10: veth-test1@veth-test2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether be:85:ba:89:b9:08 brd ff:ff:ff:ff:ff:ff
```
9. 將 veth-test1 添加到 test1 的 Namespace 裡
`sudo ip link set veth-test1 netns test1`
10. 查看 test1 的 Namespace 端口就會發現 10 號端口被加上去
`sudo ip netns exec test1 ip link`
11. 在本地查看 `ip link`，就會發現 10 不見了，因為已經添加到 test1 的 Namespace 裡面
12. 把端口也加到 test2，查看後就會發現 9 被添加到 test2 的 Namespace 裡面
`sudo ip link set veth-test2 netns test2`
`sudo ip netns exec test2 ip link`
13. 將 ip 分配給端口
`sudo ip netns exec test1 ip addr add 192.168.1.1/24 dev veth-test1`
`sudo ip netns exec test2 ip addr add 192.168.1.2/24 dev veth-test2`
14. 啟動端口
`sudo ip netns exec test1 ip link set dev veth-test1 up`
`sudo ip netns exec test2 ip link set dev veth-test2 up`
15. 執行以下命令，就會看到 ip
`sudo ip netns exec test1 ip a`
16. 透過以下指令，可以互 ping 機器
`sudo ip netns exec test1 ping 192.168.1.2`
`sudo ip netns exec test2 ping 192.168.1.1`
17. 以上就是容器互通的原理，用 linux Namespace的方式進行實現