# Docker Stack

ในการสร้าง application หนึ่งตัว เราอาจจะต้องมีการสร้างหรือบริหารจัดการ Container หลายๆ ตัว อย่างเช่น
```
docker run jaturaprom/simple-webapp
docker run mongodb
docker run redis:alpine
docker run ansible
```
หรือ อาจจะต้องใช้ docker compose มาช่วยในการบริหารจัดการ Container เช่น
docker-compose.yml
```
services:
    web:
        images: jaturaprom/simple-webapp
    database:
        image: mongodb
    messaging:
        image: redis:alpine
    orchestration:
        image: ansible
```
และจากนั้นก็ใช้คำสั่ง docker-compose up -d

แต่สำหรับระบบ Docker Swarm นั้น ก็จะคล้ายๆ กัน ตัวอย่างเช่น
```
docker service create jaturaprom/simple-webapp
docker service create mongodb
docker service create redis:alpine
docker service create ansible
```
และสำหรับ Docker Stack ก็เช่นกัน เราสามารถใช้ docker-compose ไฟล์ในการ deploy ได้เช่นกัน
docker-compose.yml
```
version: 3
services:
    web:
        images: jaturaprom/simple-webapp
    database:
        image: mongodb
    messaging:
        image: redis:alpine
    orchestration:
        image: ansible
```
และจากนั้นก็ใช้คำสั่ง 
```
docker stack deploy
```

 ### Docker Stack 
 สำหรับไอเดียของ Stack คือ 

 Stack my-app { 
     Service front-end {
         Container { nodejs x 3}
     } 
     Service messaging {
         Container { redis x 1}
     }
     Service database {
         Container { mongodb x 2}
     }    
}

### Docker Stack - Replicas
ในการการจัดการตัว Docker Stack ก็จะใช้ ymal ไฟล์ในการกำหนดคุณสมบัติ application เช่นกัน โดยรูปแบบของ docker compose
docker-compose.yml
```
version: 3
services:
    redis:
        image: redis
        deploy:
            replicas: 1
    
    db:
        image: postgress:9.4
        deploy:
            replicas: 1

    vote:
        image: voting-app
        deploy:
            replicas: 2
           
    result:
        image: result
        deploy:
            replicas: 1
    
    worker:
        image: worker
        deploy:
            replicas: 1
    
```

### Docker Stack Definition - Placement
กรณีที่ต้องการ Deploy โดยการระบุ node ว่าจะให้ container นี้ไปอยู่ที่ไหน โดยกำหนดผ่านทาง placement ภายใต้ constraints ด้วยเงื่อนไข ตัวอย่างเช่น
node.hostname เท่ากับ node1 และ node.role เท่ากับ manager เป็นต้น

```
version: 3
services:
    redis:
        image: redis
        deploy:
            replicas: 1
    
    db:
        image: postgress:9.4
        deploy:
            placement:
                constraints:
                    - node.hostname = node1
                    - node.role == manager

```

### Docker Stack Definition - Resource
เป็นการกำหนด resource ให้กับ container ตัวอย่างเช่น
```
version: 3
services:
    redis:
        image: redis
        deploy:
            replicas: 1
            resources:
                limits:
                    cpus: 0.01
                    memory: 50M
```
ข้อมูลเพิ่มเติม https://docs.docker.com/engine/swarm/services/#placement-constraints
