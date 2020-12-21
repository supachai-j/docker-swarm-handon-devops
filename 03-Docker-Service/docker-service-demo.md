# Docker Service Demo

```
docker@master01:~$ docker service create nginx                                                                                                                                                       
lqys7bft62acqtqj5dwx2cccs
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged 
docker@master01:~$
docker@master01:~$ docker service ls                                                                                                                                                                 
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
lqys7bft62ac        gallant_kalam       replicated          1/1                 nginx:latest        
docker@master01:~$
docker@master01:~$ docker service ps lq                                                                                                                                                              
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
py4u06g2w49m        gallant_kalam.1     nginx:latest        worker01            Running             Running 3 minutes ago                       
docker@master01:~$

docker@worker01:~$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
3f66a56a556b        nginx:latest        "/docker-entrypoint.…"   4 minutes ago       Up 4 minutes        80/tcp              gallant_kalam.1.py4u06g2w49mk1mc92tz9chkl
docker@worker01:~$ 
```

ลองทำการ Publish port จาก Container
```
docker@master01:~$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
lqys7bft62ac        gallant_kalam       replicated          1/1                 nginx:latest        
docker@master01:~$ docker service update lqy --publish-add 5000:80                                                                                                                                   
lqy
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged 
docker@master01:~$ docker service ls                                                                                                                                                                 
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
lqys7bft62ac        gallant_kalam       replicated          1/1                 nginx:latest        *:5000->80/tcp
docker@master01:~$ 
docker@master01:~$ docker service ps lqy
ID                  NAME                  IMAGE               NODE                DESIRED STATE       CURRENT STATE            ERROR                              PORTS
08qfbhps1cxd        gallant_kalam.1       nginx:latest        worker03            Running             Running 2 minutes ago                                       
```
ลองเข้าไปเรียกที่ ip address:5000 ของ worker03 node ดูว่าสามารถใช้งานได้หรือไม่ 

จากนั้นลอง remove service ดู
```
docker service rm lqy
```

ทำการทดสอบสร้าง service ขึ้นมาใหม่ 
```
docker@master01:~$ docker service create --replicas=2 --name my-web nginx                                                                                                                            
wmxrk2ihiqkl9fsgyp3zawqyn
overall progress: 2 out of 2 tasks 
1/2: running   [==================================================>] 
2/2: running   [==================================================>] 
verify: Service converged 
docker@master01:~$
docker@master01:~$ docker service ps my-web                                                                                                                                                          
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
dq5nh59argc2        my-web.1            nginx:latest        worker03            Running             Running 37 seconds ago                       
v55nzmnm3asz        my-web.2            nginx:latest        worker01            Running             Running 37 seconds ago                       
docker@master01:~$ 
```

ลองทำการทดสอบ ให้ my-web.1 ย้ายออกจาก worker03 เพื่อจะทำการ maintance ตัว worker03 node
```
docker@master01:~$ docker node update --availability drain worker03                    
worker03
docker@master01:~$ docker service ps my-web                                                                                                                                                          
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE             ERROR               PORTS
pywgbnx30v05        my-web.1            nginx:latest        worker02            Running             Preparing 7 seconds ago                       
dq5nh59argc2         \_ my-web.1        nginx:latest        worker03            Shutdown            Shutdown 6 seconds ago                        
v55nzmnm3asz        my-web.2            nginx:latest        worker01            Running             Running 4 minutes ago                         
docker@master01:~$ docker service ps my-web                                                                                                                                                          
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE             ERROR               PORTS
pywgbnx30v05        my-web.1            nginx:latest        worker02            Running             Running 2 seconds ago                         
dq5nh59argc2         \_ my-web.1        nginx:latest        worker03            Shutdown            Shutdown 11 seconds ago                       
v55nzmnm3asz        my-web.2            nginx:latest        worker01            Running             Running 4 minutes ago                         
docker@master01:~$    

docker@master01:~$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yhxsaqyndy6bw48jbhqow20ut *   master01            Ready               Active              Reachable           19.03.12
8c0cee901yytwiqsluqxlv15p     worker01            Ready               Active              Leader              19.03.12
ciydfcmxstzmt1jijbqmpitso     worker02            Ready               Active              Reachable           19.03.12
2y4ifrkdhi0cywd5zb4msp6cl     worker03            Ready               Drain               Reachable           19.03.12
docker@master01:~$ 
```

ลองทำการ shutdown worker01 nodes แล้วลองดูว่าจะเป็นอย่างไร
```
$docker-machine stop worker01
Stopping "worker01"...
Machine "worker01" was stopped.

docker@master01:~$ docker node ls                                                                                                                                                                    
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yhxsaqyndy6bw48jbhqow20ut *   master01            Ready               Active              Reachable           19.03.12
8c0cee901yytwiqsluqxlv15p     worker01            Down                Active              Unreachable         19.03.12
ciydfcmxstzmt1jijbqmpitso     worker02            Ready               Active              Leader              19.03.12
2y4ifrkdhi0cywd5zb4msp6cl     worker03            Ready               Drain               Reachable           19.03.12
docker@master01:~$ docker service ps my-web                                                                                                                                                          
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
pywgbnx30v05        my-web.1            nginx:latest        worker02            Running             Running 4 minutes ago                            
dq5nh59argc2         \_ my-web.1        nginx:latest        worker03            Shutdown            Shutdown 4 minutes ago                           
w7b5k2bo6gd7        my-web.2            nginx:latest        master01            Running             Running about a minute ago                       
v55nzmnm3asz         \_ my-web.2        nginx:latest        worker01            Shutdown            Running 8 minutes ago                            
docker@master01:~$
```
ปรากฎว่า my-web.2 ถูกย้ายไป running ที่ master01 แทน