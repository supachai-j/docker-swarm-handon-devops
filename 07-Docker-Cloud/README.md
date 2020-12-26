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
```
kubectl create -f pod-definition.yml
kubectl get pods
kubectl describe pods
```
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
## Demo Kubernetes on GCP
1. Setup a Google Container Engine Environement
2. Create Kubernetes PODs
3. Create Service - ClusterIP - Internal
4. Create Service - LoadBalancer - External

### Deploy Voting App Example on k8s GCP 
1. Creating voting pod and voting service
```
kubectl create -f voting-app-pod.yml
kubectl get pods
kubectl create -f voting-app-service.yml
kubectl get services
```
2. Creating redis pod and redis service
```
kubectl create -f redis-pod.yml
kubectl get pods
kubectl create -f redis-service.yml
kubectl get services
```
3. Creating postgres pod and postgres service
```
kubectl create -f postgres-pod.yml
kubectl get pods
kubectl create -f postgres-service.yml
kubectl get services
```
4. Creating worker pod 
```
kubectl create -f worker-pod.yml
kubectl get pods
```
5. Creating result pod and result service
```
kubectl create -f result-app-pod.yml
kubectl get pods
kubectl create -f result-app-service.yml
kubectl get services
```

## Play with kubernetes
http://play-with-k8s.com
1. Initializes cluster master node:
```
 kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16
```

 2. Initialize cluster networking:
```
kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
```
3. Creating pod on play-with-k8s
```
git clone https://github.com/supachai-j/kubernetes-example-voting-app.git
cd kubernetes-example-voting-app

kubectl create -f voting-app-pod.yml
kubectl create -f voting-app-service.yml

kubectl get pod
kubectl get service

kubectl describe pod

```
fixed issue with single node can run workload
```
kubectl taint nodes --all node-role.kubernetes.io/master-
```
Creating pod and service all
```
kubectl create -f .
```
Deleting pod and service all
```
kubectl delete -f .
```