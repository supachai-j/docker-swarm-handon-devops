# Docker Swarm Demo
ทำการสร้าง docker hosts โดยใช้คำสั่ง docker-machine
```
docker-machine create master01
docker-machine create worker01
docker-machine create worker02
```
## 1. Create Swarm Cluster
เข้าไปที่ docker host ที่เราต้องการเป็น swarm manager จากนั้นใช้คำสั่ง initial swarm 
```
docker-machine ssh master01 

docker@master01:~$ docker swarm init --advertise-addr 192.168.99.106                                                                                                                                 
Swarm initialized: current node (yhxsaqyndy6bw48jbhqow20ut) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-0eummf92io7dr2ea9n78laa41ltoyor7tq7r 192.168.99.106:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

docker@master01:~$ 
```
## 2. Add Worker Nodes
ทำการ join woker nodes เข้าไปยัง master node
```
docker-machine ssh worker01
docker swarm join --token SWMTKN-1-0eummf92io7dr2ea9n78laa41ltoyor7tq7rtj0jxlfhhioi7n-e3qcwng9y61pmneqlxiev0ana 192.168.99.106:2377
docker-machine ssh worker02
docker swarm join --token SWMTKN-1-0eummf92io7dr2ea9n78laa41ltoyor7tq7rtj0jxlfhhioi7n-e3qcwng9y61pmneqlxiev0ana 192.168.99.106:2377
```

เข้าไปที่ master01 แล้วใช้คำสั่ง docker node เพื่อดูว่า worker join เข้ามาแล้วหรือยัง
```
docker@master01:~$ docker node ls                                                                                                                                                                    
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yhxsaqyndy6bw48jbhqow20ut *   master01            Ready               Active              Leader              19.03.12
g6f388on06ayfia6fgj2zw5d5     worker01            Ready               Active                                  19.03.12
qqpyw2d11z3zg1tg1mml4hqsi     worker02            Ready               Active                                  19.03.12
docker@master01:~$ 
```

#### ลองใช้คำสั่ง docker swarm leave บน workder node
```
docker swarm leave
```
บน master node
```
docker node rm worker01
docker node rm worker02
```
## 3. Add Manager Nodes
วิธีการ join swarm manager nodes หลายๆ ตัว เข้าบน cluster เดียวกัน
เข้าไปที่ master node ตัวแรก จากนั้นใช้คำสั่ง
```
docker@master01:~$ docker swarm join-token manager                                                                                                                                                   
To add a manager to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-0eummf92io7dr2ea9n78laa41ltoyor7tq7rtj0jxlfhhioi7n-0grmxadtcf5kvri4308y0xt06 192.168.99.106:2377

docker@master01:~$
```
จากนั้นเข้าไปที่ master nodes ตัวอื่นๆ
```
docker@master02:~$ docker swarm join --token SWMTKN-1-0eummf92io7dr2ea9n78laa41ltoyor7tq7rtj0jxlfhhioi7n-0grmxadtcf5kvri4308y0xt06 192.168.99.106:2377
This node joined a swarm as a manager.
docker@master02:~$  
```
ลองตรวจสอบบน master node ที่เป็น Leader ดู
```
docker@master01:~$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yhxsaqyndy6bw48jbhqow20ut *   master01            Ready               Active              Leader              19.03.12
ciydfcmxstzmt1jijbqmpitso     master02            Ready               Active              Reachable           19.03.12
8c0cee901yytwiqsluqxlv15p     master11            Ready               Active              Reachable           19.03.12
docker@master01:~$  
```

ลองทดสอบ promote worker03 เป็น swarm manager 
```
docker@master01:~$ docker node ls                 
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yhxsaqyndy6bw48jbhqow20ut *   master01            Ready               Active              Leader              19.03.12
ciydfcmxstzmt1jijbqmpitso     master02            Ready               Active              Reachable           19.03.12
8c0cee901yytwiqsluqxlv15p     master11            Ready               Active              Reachable           19.03.12
2y4ifrkdhi0cywd5zb4msp6cl     worker03            Ready               Active                                  19.03.12
docker@master01:~$ docker node promote worker03                                                                                                                         
Node worker03 promoted to a manager in the swarm.
docker@master01:~$ docker node ls                                                                                                                                                                    
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yhxsaqyndy6bw48jbhqow20ut *   master01            Ready               Active              Leader              19.03.12
ciydfcmxstzmt1jijbqmpitso     master02            Ready               Active              Reachable           19.03.12
8c0cee901yytwiqsluqxlv15p     master11            Ready               Active              Reachable           19.03.12
2y4ifrkdhi0cywd5zb4msp6cl     worker03            Ready               Active              Reachable           19.03.12
docker@master01:~$
```
## 4. Quorum 

## 5. Node Failures
กรณีที่ swarm manager ตายเกิน Fault Tolerance 
```
docker@master02:~$ docker node ls                                                                                                                                                                    
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yhxsaqyndy6bw48jbhqow20ut     master01            Ready               Active              Unreachable         19.03.12
8c0cee901yytwiqsluqxlv15p *   master02            Ready               Active              Reachable           19.03.12
ciydfcmxstzmt1jijbqmpitso     master03            Ready               Active              Reachable           19.03.12
2y4ifrkdhi0cywd5zb4msp6cl     master04            Down                Active              Unreachable         19.03.12
docker@master02:~$ docker node ls                                                                                                                                                                    
Error response from daemon: rpc error: code = DeadlineExceeded desc = context deadline exceeded
docker@master02:~$
```

### Stop and Start All Docker Machine
```
docker-machine start $(docker-machine ls -q)
docker-machine stop $(docker-machine ls -q)
```