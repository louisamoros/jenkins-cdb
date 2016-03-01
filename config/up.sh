#!/bin/bash
# script to execute in jenkins
if [ -e $(docker ps -aq -f "name=mysql-test-cdb") ]
then
        echo "Creation of mysql-test-cdb..."
        docker create --name=mysql-test-cdb -e MYSQL_ROOT_PASSWORD=root louisamoros/mysql-test-cdb
fi
echo "Starting mysql-test-cdb..."
docker start mysql-test-cdb
echo "Sleeping 6 sec, waiting for mysql to be ready before launching jdk8-mvn-cdb..."
sleep 6
if [ -e $(docker ps -aq -f "name=jdk8-mvn-cdb") ]
then
        echo "Creation of jdk8-mvn-cdb..."
        docker create --name=jdk8-mvn-cdb --link mysql-test-cdb:localhost -w /cdb maven:3.3.3-jdk-8 mvn clean package
fi

echo "Copy github repo in jdk8-mvn-cdb..."
docker cp . jdk8-mvn-cdb:cdb

echo "Building..."
docker start -a jdk8-mvn-cdb

echo "Build success stopping mysql-test-cdb..."
docker stop mysql-test-cdb

echo "Copy war in current directory..."
docker cp jdk8-mvn-cdb:cdb/target/cdb.war cdb.war

echo "Copying Dockerfile for tomcat..."
cp /usr/share/jenkins/config/Dockerfile-tomcat-cdb /var/jenkins_home/jobs/cdb/workspace/

echo "Building image..."
docker build -t louisamoros/webapp-cdb .

echo "Pushing image..."
docker push louisamoros/webapp-cdb

echo "Copying glazer-deploy shell script to deploy..."
cp /usr/share/jenkins/config/glazer-deploy.sh /var/jenkins_home/jobs/cdb/workspace/

echo "Glazer will deploy..."
bash glazer-deploy.sh --host 192.168.10.225 --port 65142 --env MYSQL_ROOT_PASSWORD=root lamoros-mysql-prod-cdb louisamoros/mysql-prod-cdb
bash glazer-deploy.sh --host 192.168.10.225 --port 65142 --link lamoros-mysql-prod-cdb:localhost --publish 65142:8080 lamoros-mysql-prod-cdb louisamoros/webapp-cdb
