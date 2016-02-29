#!/bash/sh

# get the latest images version of db and environment
docker pull louisamoros/jdk8-mvn-cdb
docker pull louisamoros/mysql-test-cdb
docker rm -f mysql-test-cdb
docker rm -f jdk8-mvn-cdb

# create db test docker and start it 
docker create --name mysql-test-cdb louisamoros/mysql-test-cdb
docker start -a mysql-test-cdb

# create env docker, cp github project to its workspace and start it
docker create --name jdk8-mvn-cdb louisamoros/jdk8-mvn-cdb
docker cp . jdk8-mvn-cdb:cdb
docker start -a jdk8-mvn-cdb

