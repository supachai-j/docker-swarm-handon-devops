# Docker Network
โดยค่าเริ่มต้น จะมี network อยู่ 3 ตัวที่ถูกสร้างไว้ คือ Bridge, None และ Host
เมื่อเราใช้คำสั่ง 
```
docker run ubuntu 
```
โดย default ตัว container จะถูก attached บน network แบบ Bridge
ถ้าต้องการ attached เข้าไปยัง network แบบอื่นๆ ต้องใช้คำสั่ง
```
docker run ubuntu --netwokr=none
docker run ubuntu --network=host
```
### Bridge Network
ปกติ network แบบ Bridge ตัว Container ที่ถูกสร้างจะเชื่อมต่อเข้าไปบน docker0 (172.17.0.1), nginx-web-1 (172.17.0.2) เป็นต้น

### Host Network
ตัว Container ที่ถูกสร้างจะ Listening ip adress/port บน Docker Host เลย แต่จะมีข้อกำจัด คือ port ห้ามชนกัน

### None Network
ตัว Container จะไม่ถูกเชื่อมต่อ network กับเครือข่ายใดๆ เหมือนอยู่ตัวคนเดียวในโลก

## Overlay Network on Docker Swarm
ในการเชื่อมต่อ Container ที่อยู่แต่ละ Docker Hosts ให้สามารถเชื่อมต่อกันได้ Docker Swarm มีการสร้าง Network แบบ Overlay ขึ้นมาเพื่อให้ Container แต่ละตัวสามารถเชื่อมต่อกันภายในกันได้ โดยผ่านทาง Overlay Network โดยคำสั่งดังนี้
```
docker network create --driver overlay --subnet 10.0.9.0/24 my-overlay-network
docker service create --replicas 2 --network my-overlay-network nginx
```

## Ingress Network
โดยปกติในการเชื่อมต่อ Client เข้าไปหาบริการของ Container ได้ด้วยคำสั่ง
```
docker run -p 80:5000 my-web-server
```
Client สามารถเรียก http://192.168.1.5:80 ไปยัง Docker Host ได้โดยตรงๆ แต่ละตัว

แต่สำหรับ Swarm Cluster นั้นในการสร้าง service จากคำสั่ง 
```
docker service create --replicas 2 -p 80:5000 my-web-server 
```
กรณีแบบนี้ ถ้าเกิดว่า container ทั้งสองตัวอยู่ Docker Host (Worker node) ตัวเดียวกัน นั้นแปลกว่า เทคนิคแบบเดิม เราจะไม่สามารถ map container port กับ Host port ทั้งสอง Container เข้าไปที่ port เดียวกันได้ ดังนั้น Docker Swarm จะทำการสร้าง Ingress Network (Load Balancer) ให้เพื่อ map host port เป็น load balancer ไปหา Container ทั้งสองแทน

Client ---http://192.168.1.5:80----> *:80, Ingress Network (LB) | Docker Host | -------> *.:5000 | Container-1, Container-2| 

แบบนี้แปลว่า Ingress Network จะมีลักษณะ Overlay Network ที่ช่วยให้เวลาที่ Client วิ่งเข้ามาที่ Worker nodes ตัวไหน ก็จะสามารถเชื่อมต่อไปยัง Container ที่เราให้บริการไว้ได้
และมีการทำงานเป็น Load Balancer, Routing Mesh ให้เลย 

## Embedded DNS
บนระบบ Docker จะมี Embedded DNS ภายในเพื่อทำการ map ระหว่าง Container Name กับ ip address ในการอ้างอิง container ต่างๆ เราสามารถอ้างอิงจากชื่อ container ได้เลย

ตัวอย่างการ coding
```
mysql.connect (mysql  )
```

