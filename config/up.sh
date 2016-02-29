#!/bash/sh

# docker compose create the docker-compose.yml to set dockers
docker-compose create --force-recreate -d -p /config/docker-compose.yml

# add github repository to jdk8-mvn-cdb
docker cp . jdk8-mvn-cdb:cdb

# start building with docker compose
docker-compose start -a -p /config/docker-compose.yml

# copy builded war
docker cp jdk8-mvn-cdb:cdb/target/*.war webapp.war
docker build -t louisamoros/webapp-cdb .
docker push louisamoros/webapp-cdb


