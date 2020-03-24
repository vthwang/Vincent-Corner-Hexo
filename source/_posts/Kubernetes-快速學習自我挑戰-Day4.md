---
title: Kubernetes 快速學習自我挑戰 Day4
thumbnail:
  - /images/learning/kubernetes/kubernetesday4.jpg
date: 2017-08-20 14:27:44
categories: Study Note
tags: Kubernetes
---
<img src="/images/learning/kubernetes/kubernetesday4.jpg">

***
### 進階的主題
#### 深入 Service
1. 在 Kubernets 1.3，DNS 是一個**內建**的 service 且會自動使用 addon 管理器啟動
    - addon 在 **master node** 的 etc/kubernetes/addons **目錄**
2. DNS 服務可以在 pod 裡面被使用，且**找到其它服務**運行在相同的 cluster 上
3. **在一個 pod 中**的很多 containers 的架構不需要這種 service，因為它們可以**直接**互相**聯繫**
    - 在相同 pod 中的 container 可以使用 **localhost:port**
4. 為了要讓 DNS 可以運作，pod 需要 **Service Definition**
#### Demo：深入 Service
1. `cat service-discovery/secrets.yml`
2. `kubectl create -f service-discovery/secrets.yml`
3. `cat service-discovery/database.yml`
4. `cat service-discovery/database-service.yml`
5. `kubectl create -f service-discovery/database.yml`
6. `kubectl create -f service-discovery/database-service.yml`
7. `cat service-discovery/helloworld-db.yml`
    - 這邊會發現 env 下的 value: database-service，因為在創建 database-service.yml 的 metadata name 也是使用這個名稱
8. `kubectl create -f service-discovery/helloworld-db.yml`
9. `kubectl create -f service-discovery/helloworld-db-service.yml`
10. `minikube service helloworld-db-service --url`
11. `kubectl get pods`
12. 確認是否連線到資料庫
`kubectl logs helloworld-deployment-2141920616-5bzp0`
13. curl 剛剛取得的 ip
`curl http://192.168.99.100:30888`
14. `kubectl exec database -i -t -- mysql -u root -p` 密碼是 rootpassword
15. `show databases;`
16. `use helloworld`
17. `show tables;`
18. `select * from visits;`
19. `\q`
20. `kubectl run -i --tty busybox --image=busybox --restart=Never -- sh`
21. `nslookup helloworld-db-service`
22. `nslookup database-service`
23. `telnet helloworld-db-service 3000`
24. `kubectl delete pod busybox`
#### ConfigMap
1. 設定參數不是秘密，可以放在 **ConfigMap**
2. Input 是**重複的** key-value pairs
3. ConfigMap **key-value pairs** 可以被 app 讀取，使用：
    - **環境**變數
    - 在 Pod 設定裡面的 **Container commandline arguments**
    - 使用 **voulmes**
4. ConfigMap 也可以包含 **full configuration** 檔案
    - 例如：網頁伺服器的 config 檔案
5. 這些檔案可以被使用 volumes 的方式**掛接**，而 volumes 正是 application 放置 config file 的地方
6. 這樣的方法可以**輸入**配置設置到 containers 裡面，而不需要改變 container 本身
7. 使用檔案產生 ConfigMap
```
driver=jdbc
database=postgres
lookandfeel=1
otherparams=xyz
param.with.hierarchy=xyz
EOF
```
`kubectl create configmap app-config --from-file=app.properties`
8. 可以使用 volume 來 expose ConfigMap 的方式創建 pod
```
apiVersion: v1
kind: Pod
metadata:
    name: nodehelloworld.example.com
    labels:
        app: helloworld
spec:
    containers:
    - name: k8s-demo
      image: wardviaene/k8s-demo
      ports:
      - containerPort: 3000
      volumeMounts:
      - name: config-volume
      // config 檔案會被存在 /ect/config/driver、/etc/config/param/with/hierarchy
        mountPath: /etc/config
      volumes:
      - name: config-volume
        configMap:
          name: app-config
```
9. 可以使用環境變數來 expose ConfigMap 的方式創建 pod
```
apiVersion: v1
kind: Pod
metadata:
    name: nodehelloworld.example.com
    labels:
        app: helloworld
spec:
    containers:
    - name: k8s-demo
      image: wardviaene/k8s-demo
      ports:
      - containerPort: 3000
      env:
          - name: DRIVER
            valueFrom:
              configMapKeyRef:
                name: app-config
                key: driver
          - name: DATABASE
          [...]
```
#### Demo：ConfigMap
1. `cat configmap/reverseproxy.conf`
2. `kubectl create configmap nginx-config --from-file=configmap/reverseproxy.conf`
3. `kubectl get configmap`
4. `kubectl get configmap nginx-config -o yaml`
5. `cat configmap/nginx.yml`
6. `kubectl create -f configmap/nginx.yml`
7. `kubectl create -f configmap/nginx-service.yml`
8. `minikube service helloworld-nginx-service --url`
9. `curl http://192.168.99.100:31965 -vvv`
10. `kubectl exec -i -t helloworld-nginx -c nginx -- bash`
11. `ps x`
12. `cat /etc/nginx/conf.d/reverseproxy.conf`
#### Ingress Controller
1. Ingress 是一個從 Kubernetes 1.1 之後可用的解決方案，用來允許 **inbound connections** 給 cluster
2. 它是 external **Loadbalancer** 和 **nodePorts** 的替代方案
    - Ingress 允許**簡單的 expose services**，如果 services 需要從 **cluster 外部** 存取
3. 如果有 Ingress 就可以在 Kubernetes 運行自己的 **ingress controller** (基本上就是 loadbalancer) 
4. 有預設的 ingress controllers 可以使用，或是也可以**寫自己的** ingress controller
5. 可以使用 ingress object 來創建 ingress rules
```
apiVersion: extensions/v1beta1
kind: ingress
metadata:
    name: helloworld-rules
spec:
    rules:
    - host: helloworld-v1.example.com
      http:
          paths:
          - path: /
            backend:
                serviceName: helloworld-v1
                servicePort: 80
    - host: hellowrld-v2.example.com
      http:
          paths:
          - path: /
            backend:
                serviceName: helloworld-v2
                servicePort: 80
```
#### Demo：Ingress Controller
1. `cat ingress/nginx-ingress-controller.yml`
2. `cat ingress/ingress.yml`
3. `kubectl create -f ingress/ingress.yml`
4. `kubectl create -f ingress/nginx-ingress-controller.yml`
5. `kubectl create -f ingress/echoservice.yml`
6. `kubectl create -f ingress/helloworld-v1.yml`
7. `kubectl create -f ingress/helloworld-v2.yml`
8. helloworld-v2 和 v1 的差別在於 image 版本
9. `minikube ip`
10. `curl 192.168.99.100`
11. `curl 192.168.99.100 -H 'Host: helloworld-v1.example.com'`
12. `curl 192.168.99.100 -H 'Host: helloworld-v2.example.com'`
13. `kubectl get svc`
#### Volumes
1. Kubernetes 裡面的 Volumes 用來**儲存 container 之外的 data**
2. 當 container **停止**，所有在 container 裡面的資料會 **不見**
    - 這正是為什麼我們一直執行 **stateless** 的 apps：apps 不會保留 **本地** state，但是會儲存它們的 state 到 **外部 service**
        - 外部 Service 像是 database，快取伺服器 (例如：MySQL、AWS S3)
3. Kubernetes 裡面的 Persistent Volumes 可以 **連接一個 volume** 到 container，而檔案會繼續**存在**就算 **container** 停止
4. Volumes 可以使用不同的 **volume plugins** 來連接
    - 本地 Volume
    - AWS Cloud：EBS Storage
    - Google Cloud：Google Disk
    - 網路儲存空間：NFS、Cephfs
    - Microsoft Cloud：Azure Disk
5. 使用 Volumes 可以在 cluster 上部署 **application with state**
    - 這些應用必須要在**本地檔案系統**讀/寫檔案，而且需要持續存在
6. 可以運行 **MySQL** 資料庫且使用 persistent volumes
    - 雖然這還沒準備好產品化
    - Volumes 是 Kubernetes 在 2016 年 6 月發佈的，所以還很新，關於這個部分還需要多加**注意**
7. 如果 **node 停止**運行，pod 會重新排程到另外一個 node，然後 volume 可以被連接到新的 node
8. 使用 volumes 必須要先**創建 volume**
9. 使用 volumes 必須要**創建**有 volume definition 的 **pod**
#### Demo：Volumes
1. `aws ec2 create-volume --size 10 --region ap-northeast-1 --availability-zone ap-northeast-1a --volume-type gp2`
2. 把剛剛拿到的 VolumeId 貼近去 `vim volumes/helloworld-with-volume.yml`
3. `kubectl create -f volumes/helloworld-with-volume.yml`
4. `kubectl get pod`
5. `kubectl describe pod helloworld-deployment-2277790027-3c1q2`
6. `kubectl exec helloworld-deployment-2277790027-3c1q2 -i -t -- bash`
7. `ls -ahl /myvol/`
8. `echo 'test' > /myvol/myvol.txt`
9. `echo 'test2' > /test.txt`
10. `kubectl drain ip-172-20-49-46.ap-northeast-1.compute.internal --force`
11. `kubectl get pod`
12. `kubectl exec helloworld-deployment-2277790027-ll7w0 -i -t -- bash`
13. `ls -ahl /myvol/myvol.txt`
14. `ls -ahl /test.txt` => 這會找不到，因為沒有存在 volume，而是存在 container
15. `kubectl delete -f volumes/helloworld-with-volume.yml`
16. `aws ec2 delete-volume --volume-id vol-0ae6788e2541f0252 --region ap-northeast-1`