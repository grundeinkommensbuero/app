#!/bin/sh
db_url=$1
db_port=$2
db_schema=$3
db_user=$4
db_password=$5
key_password=$6
printf "%s" "waiting for database $1:$2/$3 to run ..."
i=1
while ! (echo >/dev/tcp/$db_url/$db_port) &> /dev/null
do
  i=$((i+1))
  sleep 1
  printf "%c" "."
  if [ $i -gt 20 ]
  then
    printf "\n%s\n"  "Database did not respond in time, exiting..."
    exit
  fi
done
printf "\n%s\n"  "Database responded, starting server..."
/opt/jboss/wildfly/bin/standalone.sh \
  -b "0.0.0.0" \
  -bmanagement "0.0.0.0" \
  -DDB_URL=$db_url \
  -DDB_PORT=$db_port \
  -DDB_SCHEMA=$db_schema \
  -DDB_USER=$db_user \
  -DDB_PASSWORD=$db_password \
  -DKEY_PASSWORD=$key_password \
  --debug