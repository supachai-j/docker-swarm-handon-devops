#!/bin/sh

# creating docker hosts
docker-machine create node01
docker-machine create node02
docker-machine create node03

#get ip address from master01
master_ip=`docker-machine ip node01`

# docker swarm init
docker-machine ssh master01 "docker swarm init --advertise-addr $master_ip"
 