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
17. 以上就是容器互通的原理，用 linux Namespace 的方式進行實現
### Docker bridge0 詳解
1. 停止 test2 容器並刪除
`docker stop test2`
`docker rm test2`
2. 列出 docker 機器的網路
`docker network ls`
3. 查看 bridge 網路的內容，會發現裡面有一項是 containers，而 container 正是 test1，就會知道 test1 的網路正是連接到這個 bridge
`docker network inspect c6e6281b109f`
4. 使用 `ip a` 查看虛擬機的網路列表，會輸出以下內容，裡面可以看到虛擬機的 docker0 接口用 veth 連線到容器裡面的網路
```
4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:80:06:0b:9a brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:80ff:fe06:b9a/64 scope link
       valid_lft forever preferred_lft forever
6: veth25ca999@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether ee:18:e0:2f:0c:56 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::ec18:e0ff:fe2f:c56/64 scope link
       valid_lft forever preferred_lft forever
```
5. 使用 `docker exec test1 ip a` 列出 test1 容器的網路，會輸出以下內容，會發現 eth0 是和上面的 veth25ca999 連在一起的
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
5: eth0@if6: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
```
6. 安裝 Bridge-utils 驗證連線
`sudo apt-get install -y bridge-utils`
7. 在虛擬機使用 `brctl show`，就會看到 docker0 是和 veth25ca999 連接的
8. 再開啟一個 test2 的容器
`docker run -d --name=test2 busybox /bin/sh -c "while true; do sleep 3600; done"`
9. 再次檢查 bridge 的網路，就會發現多一個 test2 的容器
`docker network inspect bridge`
10. 這時候再執行一次 `ip a`，就會發現多一個 veth，因為多一個容器，就需要多一條線進行連接
```
4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:80:06:0b:9a brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:80ff:fe06:b9a/64 scope link
       valid_lft forever preferred_lft forever
6: veth25ca999@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether ee:18:e0:2f:0c:56 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::ec18:e0ff:fe2f:c56/64 scope link
       valid_lft forever preferred_lft forever
10: veth93b61b7@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether ea:ed:e9:82:86:dc brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::e8ed:e9ff:fe82:86dc/64 scope link
       valid_lft forever preferred_lft forever
```
11. 再次執行 `brctl show`，就會發現 docker0 連接兩個 veth

| bridge name | bridge id | STP enabled | interfaces |
|:--:|:--:|:--:|:--:|
| docker0 | 8000.024280060b9a | no | veth25ca999 |
|  |  |  | veth93b61b7 |

12. 以下圖片解釋 (1) 容器之間如何互相溝通 (2) 容器如何連接到外網

<img src="/images/learning/docker-2/DockerDay04-Image02.png">

### 容器之間的 Link
1. 停止 test2 容器並刪除
`docker stop test2`
`docker rm test2`
2. 再次創建 test2 容器並 link 到 test1，使用 --link 就是新增 dns 紀錄
`docker run -d --name=test2 --link=test1 busybox /bin/sh -c "while true; do sleep 3600; done"`
3. 進去 test2 裡面執行命令
`docker exec -it test2 /bin/sh`
4. 使用 `ping test1`，會發現可以 ping 到容器 test1
5. link 是有方向性的，因為只在 test2 link 到 test1，所以可以在 test2 容器 ping test1 容器，但是在 test1 上面是沒有辦法直接用 `ping test2` 來 ping 到 test2 容器的
6. 再次停止 test2 容器並刪除，再次創建 test2，但是不要 link
`docker stop test2`
`docker rm test2`
`docker run -d --name=test2 busybox /bin/sh -c "while true; do sleep 3600; done"`
7. 自己新增一個 Bridge
`docker network create -d bridge my-bridge`
8. 用 `docker network ls` 就可以查看新增的 bridge
9. 用 `brctl show` 查看，就可以看到新增的 bridge
10. 新增 test3 容器，並連接到新增的 bridge
``docker run -d --name=test3 --network my-bridge busybox /bin/sh -c "while true; do sleep 3600; done"``
11. 用 `brctl show` 查看，就會看到新增的 bridge 連接到 test3 容器上
12. 也可以用 `docker network inspect my-bridge` 查看新增的 bridge 連接到 test3 容器上
13. 可以將已存在的容器連接到新增的 bridge 上面
`docker network connect my-bridge test2`
14. 再用 `docker network inspect my-bridge` 查看新增的 bridge 也已連接到 test2 容器上
15. 進去 test3 容器執行命令
`docker exec -it test3 /bin/sh`
16. 在 test3 容器直接 ping test2，但是沒有使用 link，還是可以 ping 通，因為默認自己新增的 bridge 上的容器會自動 link
`ping test2`
17. 再進入 test2 容器執行命令
`docker exec -it test2 /bin/sh`
18. 嘗試 `ping test3` 可以通，但是 `ping test1` 就不能通了，因為**默認自己新增的 bridge 上的容器會自動 link**
19. 將 test1 連接到 my-bridge，再進去 test2 容器，ping test1 就可以通了。
`docker network connect my-bridge test1`
`docker exec -it test2 /bin/sh`
`ping test1`
### 容器端口映射
1. 新增一個 nginx 的容器
`docker run --name web -d nginx`
2. 查看 web 的 ip 地址
`docker network inspect bridge`
3. ping web 的容器，會發現在虛擬主機上是可以 ping 通的
`ping 172.17.0.4`
4. 使用 telnet 測試網站是否可以連線，發現也可以連線
`telnet 172.17.0.4 80`
5. 使用 curl 也可以把 html 頁面顯示出來，這樣就可以知道可以訪問 web 容器的 80 服務
`curl http://172.17.0.4`
6. 先把 web 容器停止並刪除
`docker stop web`
`docker rm web`
7. 新增 web 容器，並把容器的 80 port 映射到虛擬主機的 80 port 
`docker run --name web -d -p 80:80 nginx`
8. 在虛擬主機上 `curl 127.0.0.1`，就會出現 html 頁面