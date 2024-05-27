#!/bin/bash
cd /home/sid/dockerfiles/ubuntu
# Stop and remove containers if they exist
sudo docker container ls -aq | grep "ubuntu" | xargs docker container rm -f
sudo docker build -t ubuntu .
sudo docker run --name ubuntu -it ubuntu /bin/bash
