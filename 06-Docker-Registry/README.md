# Docker Registry

## Public Docker Registry - dockerhub
```
docker build . -t jaturaprom/my-custom-app
docker push jaturaprom/my-custom-app
```

## Private Docker Registry
```
docker run -d -p 5000:5000 registry:2
docker build . -t  jaturaprom/my-custom-app
docker push localhost:5000/jaturaprom/my-custom-app
```

## Docker Playground
https://labs.play-with-docker.com
login with Docker ID and enter start bottom, +new instance
```
docker run -d -p 5000:5000 --restart always --name registry registry:2
docker pull nginx
docker images
docker tag nginx localhost:5000/nginx:1
docker images
docker push localhost:5000/nginx:1

docker rmi localhost:5000/nginx:1
docker images
docker pull localhost:5000/nginx:1

```

### Web GUI for Private Docker Registry  
```
docker run \
-d \ 
-e ENV_DOCKER_REGISTRY_HOST=registry \
-e ENV_DOCKER_REGISTRY_PORT=5000 \
-p 8080:80 \
--link registry:registry \ 
konradkleine/docker-registry-frontend:v2
```