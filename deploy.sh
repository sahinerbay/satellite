#!/bin/bash

docker image build --target dev -t frontend:dev .

containerId=`docker container ls -q --filter expose=80`

# Stop the container if it's running on port 80
if [ ! -z $containerId ] 
then
  docker container stop $containerId
fi
  
docker container run -d --rm -p 8081:80 frontend:dev