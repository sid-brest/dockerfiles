#!/bin/bash

cd /home/sid/dockerfiles/zabbix

# Stop and remove containers if they exist
sudo docker stop zabbix-web-nginx-mysql 2>/dev/null && sudo docker rm zabbix-web-nginx-mysql
sudo docker stop mysql-server 2>/dev/null && sudo docker rm mysql-server
sudo docker stop zabbix-server-mysql 2>/dev/null && sudo docker rm zabbix-server-mysql
sudo docker stop zabbix-java-gateway 2>/dev/null && sudo docker rm zabbix-java-gateway

# Remove network if it exists
sudo docker network rm zabbix-net 2>/dev/null

# Create a Docker network with a specified subnet
sudo docker network create --subnet=172.28.0.0/16 zabbix-net

# Deploy containers

# MySQL container with a static IP
sudo docker run --name mysql-server -t \
    -e MYSQL_DATABASE="zabbix" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="sertis" \
    -e MYSQL_ROOT_PASSWORD="sertis" \
    --network=zabbix-net --ip 172.28.0.2 \
    --restart unless-stopped \
    -d mysql:8.0 \
    --character-set-server=utf8 --collation-server=utf8_bin \
    --default-authentication-plugin=mysql_native_password

# Zabbix Java Gateway container with a static IP
sudo docker run --name zabbix-java-gateway -t \
    --network=zabbix-net --ip 172.28.0.3 \
    --restart unless-stopped \
    -d zabbix/zabbix-java-gateway:latest

# Zabbix server container with a static IP
sudo docker run --name zabbix-server-mysql -t \
    -e DB_SERVER_HOST="172.28.0.2" \
    -e MYSQL_DATABASE="zabbix" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="sertis" \
    -e ZBX_JAVAGATEWAY="172.28.0.3" \
    --network=zabbix-net --ip 172.28.0.4 \
    -p 10051:10051 \
    --restart unless-stopped \
    -d zabbix/zabbix-server-mysql:latest

# Zabbix Web-nginx container with a static IP
sudo docker run --name zabbix-web-nginx-mysql -t \
    -e ZBX_SERVER_HOST="172.28.0.4" \
    -e DB_SERVER_HOST="172.28.0.2" \
    -e MYSQL_DATABASE="zabbix" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="sertis" \
    --network=zabbix-net --ip 172.28.0.5 \
    -p 8080:8080 \
    --restart unless-stopped \
    -d zabbix/zabbix-web-nginx-mysql:latest