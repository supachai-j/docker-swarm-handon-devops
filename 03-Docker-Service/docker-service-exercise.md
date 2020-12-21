# Docker Service Exercise
1. Input a command in the command file to create a new service. Use the image voting-app for this.
```
docker service create voting-app
```
2. Let us name the service - "vote". Add a name option to name the service "vote".
```
docker service create --name vote voting-app
```
3. The current command only one creates one instance of voting-app. Let us update the command to create 3 instance. Add a --replicas option and provide a value of 3.
```
docker service create --name vote --replicas 3 voting-app
```
4. Since our application is a web application it needs ports to be published. The web application exports port 80. Add a port publish option to publish port 80 to port 8080 on the host. ote the format: -p <host port>:<container port>
```
docker service create --name vote --replicas 3 -p 8080:80 voting-app
```
5. We would like to attache the services to a dedicated front-end network add a network option to attach the service to front-end network.
```
docker service create --replicas 3 --name vote -p 8080:80 --network front-end voting-app
```
6. We have the service running with 3 containers. At a later point in time we decide to update the service to have 6 containers. input a command in the command file to update service "vote" to have 6 replicas.
```
docker service update --replicas 6 vote
```