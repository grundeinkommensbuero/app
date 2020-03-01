#!/bin/sh
printf "%s" "waiting for database to run ..."
i=1
while ! (echo >/dev/tcp/db/3306) &> /dev/null
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
/opt/jboss/wildfly/bin/standalone.sh -b "0.0.0.0" -bmanagement "0.0.0.0"