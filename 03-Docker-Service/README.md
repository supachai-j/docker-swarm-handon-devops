# Docker Service

### Docker run Command
ปกติเราใช้คำสั่ง docker run ในการสร้าง container ของเราซึ่งเป็นการสร้างในแต่ละ Docker host
```
docker run my-web-app
```
### Docker Service Command
แต่สำหรับการสร้าง Container บน Swarm Cluster ให้เราใช้คำสั่ง docker service แทน
```
docker service create --replicas=3 my-web-app
```
ซึ่งคำสั่งอื่นๆ ที่เคยใช้กับ docker run ก็สามารถใช้งานได้เช่นกัน
```
docker service create --replicas=3 -p 8080:80 my-web-app
docker service create --replicas=3 --network frontend  my-web-app
```
ในการสั่งงานต่างๆ บน Swarm cluster จะถูกสั่งที่ 
docker service command ----> Orchestrator ------> Scheduler | Manager Nodes | ---------------------------> Task | Worker Nodes |

### Replicas vs Global
การใช้คำสั่ง Replicas และ Global
```
docker service create --replicas=3 my-web-app
docker service create --mode global my-monitor-agent
```
--replicas คือจะทำการกระจายโหลดตามจำนวนที่กำหนด ไปบน Worker nodes
--mode global คือการสร้าง container บนทุก worker nodes

### Service Name
ในการกำหนด ชื่อของ Service ของเราก็สามารถใช้คำสั่ง
```
docker service create --replicas=3 --name web-server my-web-server 
```
โดยชื่อของ container เราจะถูกเติมด้วย name.number เช่น web-server.1 , web-server.2 ในแต่ละ worker nodes

### Service Update
ในการ update หรือเปลี่ยนค่าต่างๆ บน swarm cluster
```
docker service create --replicas=3 --name web-server my-web-server
docker service update --replicas=4 web-server 
```