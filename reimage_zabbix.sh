#!/bin/bash
cd /home/sid/dockerfiles/zabbix
sudo docker stop zabbix-web-nginx-mysql && sudo docker rm zabbix-web-nginx-mysql
sudo docker stop mysql-server && sudo docker rm mysql-server
sudo docker stop zabbix-server-mysql && sudo docker rm zabbix-server-mysql
sudo docker stop zabbix-java-gateway && sudo docker rm zabbix-java-gateway
sudo docker network rm zabbix-net

# sudo apt-get update -y && sudo apt-get dist-upgrade -y && sudo apt autoremove
sudo docker network create zabbix-net

sudo docker run --name mysql-server -t \
    -e MYSQL_DATABASE="zabbix" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="sertis" \
    -e MYSQL_ROOT_PASSWORD="sertis" \
    --network=zabbix-net \
    --restart unless-stopped \
    -d mysql:8.0 \
    --character-set-server=utf8 --collation-server=utf8_bin \
    --default-authentication-plugin=mysql_native_password

sudo docker run --name zabbix-java-gateway -t \
    --network=zabbix-net \
    --restart unless-stopped \
    -d zabbix/zabbix-java-gateway:latest

sudo docker run --name zabbix-server-mysql -t \
    -e DB_SERVER_HOST="mysql-server" \
    -e MYSQL_DATABASE="zabbix" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="sertis" \
    -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
    --network=zabbix-net \
    -p 10051:10051 \
    --restart unless-stopped \
    -d zabbix/zabbix-server-mysql:latest

sudo docker run --name zabbix-web-nginx-mysql -t \
    -e ZBX_SERVER_HOST="zabbix-server-mysql" \
    -e DB_SERVER_HOST="mysql-server" \
    -e MYSQL_DATABASE="zabbix" \
    -e MYSQL_USER="zabbix" \
    -e MYSQL_PASSWORD="sertis" \
    --network=zabbix-net \
    -p 80:80 \
    --restart unless-stopped \
    -d zabbix/zabbix-web-nginx-mysql:latest