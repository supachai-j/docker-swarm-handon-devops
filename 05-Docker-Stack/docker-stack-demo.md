# Docker Stack Demo
ในส่วนของการ deploy application ผ่านทาง Docker Stack จะใช้ docker compose ไฟล์​ จากนั้นก็ใช้คำสั่ง
```
docker stack deploy voting-app-stack --compose-file docker-stack.yml
```
### Docker Stack 1
Introduction: Given below is the contents of the docker-compose file from the previous coding exerices. We would now like to deploy our application on Docker Cloud using stack files. The current docker compose file can be easily converted to docker-stack.yml file and it works just fine. So we have renamed the file from docker-compose.yml to docker-stack.yml. However, this only deploys a single instance of each element. We would like to deploy multiple instance of these.
Instruction: Update the docker-stack.yml file to include a deploy section under each service and add replicas parameter to run 1 instances of redis, db, worker and result applications. Deploy 2 instances of vote app.

Solution: [docker-stack-1](docker-stack-1.yml)

### Docker Stack 2
Introduction: In our design, the db server is always required to be placed on the manager node. Add a placement constraint on the db server to fulfill this requirement.
Instruction: Add a placement property under deploy in db service. Under placement add constraints property add provide that value [node.role == manager]

Solution: [docker-stack-2](docker-stack-2yml)

### Docker Stack 3
Introduction: We would like the worker-app to restart automatically when if fails. But every time it fails wait for 10 seconds beforce restarting.
Instruction: Add a restart_policy option under deploy section in the worker service. Under it add a property condition with a value of on-failure and another property - delay with a value of 10s.

Solution: [docker-stack-3](docker-stack-3.yml)

### Docker Stack 4
Introduction: if we were to update the voting-app services, we would like to update the container under the service on at a time.
Instruction: Add a update_config property under the deploy section in vote service. Supply a property parallelism under it and provide a value of 2.

Solution: [docker-stack-4](docker-stack-4.yml)