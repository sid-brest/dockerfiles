#!/bin/bash

cd /home/sid/dockerfiles/ubuntu

# Stop and remove containers matching "ubuntu" in their name
containers=$(docker ps -aq --filter "name=ubuntu")
if [ -n "$containers" ]; then
    docker stop $containers
    docker rm $containers
fi

# Build the Docker image
docker build -t ubuntu .

# Run the Docker container
docker run --name ubuntu -it ubuntu /bin/bash