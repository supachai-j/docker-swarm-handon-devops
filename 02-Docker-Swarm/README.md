# Docker Swarm
Docker swarm คือ Orchestrator ในการบริหารจัดการ Docker Host Clustering โดยจะมี  Swarm Manager และ  Worker Nodes
วิธีการ Setup Swarm บน Swarm Manager จะใช้คำสั่ง 
```
docker swarm init --advertise-addr 192.168.1.12
```
และส่วนของ Worker Nodes ต่างๆ ก็สามารถ join swarm cluster ได้โดยคำสั่ง
```
docker swarm join --token <token>
```

Swarm Manager เป็นตัวที่บริหารจัดการ workload ต่างๆ ให้กับ worker nodes และ Swarm Manager สามารถมีได้หลายๆ ตัวได้ (Multiple Swarm Manager) ซึ่งจะมี Swarm Manager หนึ่งตัวเป็น Leader และตัวอื่นๆ จะเป็น Followersโดยจะใช้เทคนิคที่ชื่อว่า Distributed Consensus -  [RAFT Algorithm](https://raft.github.io/) เพื่อให้แต่ละ Swarm Manager มีข้อมูลเท่ากันทั้งหมด เมื่อตัว Leader หายไป ตัวอื่นๆ จะเลือกกันเป็น Leader แทน

แล้วคำถามว่า "How Many manager Nodes ?" 
คำตอบคือ 
Quorum of N = (N+1)/2
Fault Tolerance of N = (N-1)/2

Example 
Quorum of 3 , (3+1)/2 = 2
Fault Tolerance of 3 = (3-1)/2 = 1

จากสูตรข้างต้น โดยปกติ minimum recommend ใน cluster จะเป็น Swarm Manager 3 nodes เพราะสามารถทำ Fault Telerance ได้  1 Node.

### Cluster Failture
กรณีที่ 2 nodes manager หายไปแล้ว ต้องทำให้ 1 node ที่เหลือทำงาน โดยใช้คำสั่ง 
```
docker swarm init --force-new-cluster
```
 คำสั่งที่ทำให้ Worker nodes เป็น Swarm Manager ด้วย
 ```
 docker node promote
 ```
คำสั่งสามารถไม่รับงานใหม่และเป็น maintanace โหมดได้ โดยใช้คำสั่งที่ตัวที่เป็น Leader
```
docker node update --availability drain <Node>
```

### Next Step 
- [Docker Swarm Demo](docker-swarm-demo.md)
