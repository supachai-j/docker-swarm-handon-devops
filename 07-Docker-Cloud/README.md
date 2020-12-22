# Docker Cloud

## Docker cloud จะให้บริการ
- build images
- infrastructure
- Configure Docker
- Configure Swarm
- Manage Nodes
- Manage Services

## Cloud Providers
- AWS
- Digital Ocean
- Microsoft Azure
- SoftLayer
- Packet

## Source Provider 
- GitHub
- BitBucket
- GitLab

## Docker Cloud 
Dev Feauter#1 -----> Code Repository (GitHub) -----> Build System (Docker Cloud) -----> Release (Docker Hub)


## Kubernetes Overview
เป็น Docker Orchestration ที่ช่วยบริหารจัดการระบบ Container ทำให้ง่ายมากยิ่งขึ้น 

kubectl create -f pod-definition.yml
kubectl get pods
kubectl describe pods

### Kubernetes Define files
ในการสั่งงานหรือกำหนดพฤติกรรมต่างๆ ของ K8s ต้องทำผ่านไฟล์ในรูปแบบของ yaml ไฟล์
- Version       เป็นการกำหนดรูปแบบว่าใช้ version อะไร
- Kind          เป็นการระบุว่าจะกำหนดรูปแบบตัวไหน Pod, Deployment, Service
- Metadata      เป็นการข้อมูลเพิ่มเติมในการอ้างอิงเช่น Name, Lables
- Specification เป็นส่วนของการกำหนดการตั้งค่าหรือคุณสมบัติต่างๆ ของสิ่งที่เราต้องการจะทำเช่น container, ports

pod-defination.yml
```
apiVersion: v1

Kind: pod

metadata:
    name: nginx

spec:
    containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
```
จากนั้นก็ใช้คำสั่ง 
```
kubectl create -f pod-defination.yml
```

