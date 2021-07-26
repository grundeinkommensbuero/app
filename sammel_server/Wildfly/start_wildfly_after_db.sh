#!/bin/sh
printf "%s" "waiting for database $DB_URL:$DB_PORT/$DB_SCHEMA to run ..."
i=1
while ! (echo >/dev/tcp/$DB_URL/$DB_PORT) &> /dev/null
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

printf "\n%s\n"  "Richte Standard-Admin-Nutzer ein"
/opt/jboss/wildfly/bin/add-user.sh admin $SERVER_PASSWORD --silent

printf "\n%s\n"  "Database responded, starting server..."
/opt/jboss/wildfly/bin/standalone.sh \
  -b "0.0.0.0" \
  -bmanagement "0.0.0.0" \
  -Ddb_url=$DB_URL \
  -Ddb_port=$DB_PORT \
  -Ddb_schema=$DB_SCHEMA \
  -Ddb_user=$DB_USER \
  -Ddb_password=$DB_PASSWORD \
  -Dstore_name=$STORE_NAME \
  -Dstore_password=$SERVER_PASSWORD \
  -Dmode=$MODE \
  -Dkey=$KEY \
  --debug