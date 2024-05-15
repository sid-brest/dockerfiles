#!/bin/bash
cd /home/sid/dockerfiles/quickstart
sudo apt-get update -y && sudo apt-get dist-upgrade -y && sudo apt autoremove
sudo docker stop sertis && sudo docker rm sertis
sudo docker image rm sertis_by
sudo docker build --no-cache -t sertis_by .
sudo docker run -d -p 80:80 --name sertis sertis_by