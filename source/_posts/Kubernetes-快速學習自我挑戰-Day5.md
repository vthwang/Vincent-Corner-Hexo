---
title: Kubernetes 快速學習自我挑戰 Day5
thumbnail:
  - /blogs/images/learning/kubernetes/kubernetesday5.png
date: 2017-08-22 00:46:53
categories: 學習歷程
tags: Kubernetes
---
<img src="/blogs/images/learning/kubernetes/kubernetesday5.png">

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

















