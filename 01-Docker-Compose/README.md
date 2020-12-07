# 01 Docker Compose

Lab 1: Creating docker-compose.yml file under the path /root/wordpress. service-name: wordpress, Host-port: 8085 and service-name: db, environment:POSTGRES_PASSWORD=mysecretpassword

Creating directory
```
mkdir /root/wordpress
cd /root/wordpress
```
docker-compose.yml
```
version: '3.0'
services:
 wordpress:
    image: wordpress
    ports:
     - 8085:80
    links:
     - db
 db:
   image: postgres
   environment:
    - POSTGRES_PASSWORD=mysecretpassword
```
Run docker compose up.
```
docker-compose up -d
```
Lab 2: Create a docker-compose.yml file under the path /root/jenkins. Once done, run a docker-compose up. Name: jenkins Image: jenkins/jenkins:lts ports: hostport: 8089 --> Container Port: 8080 hostport: 50000 --> Container Port: 50000
Volume jenkins_home mapped to directory /var/jenkins_home

Creating directory
```
mkdir /root/jenkins
cd /root/jenkins
```
docker-compose.yml
```
version: '3.0'
services:
 jenkins:
    image: jenkins/jenkins:lts
    ports:
     - 8089:8080
     - 50000:50000
    volumes:
     - jenkins_home: 
volumes:
    jenkins_home:/var/jenkins_home
```
Run docker compose up.
```
docker-compose up -d
```