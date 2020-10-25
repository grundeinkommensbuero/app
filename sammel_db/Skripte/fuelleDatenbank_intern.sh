#!/bin/bash
files=$(ls /home/Skripte | grep sql$)
echo "Führe Skripte aus:"
for script in $files
do
  echo -n "-> /home/Skripte/$script "
  mysql -D db -u root --password=$MYSQL_ROOT_PASSWORD < /home/Skripte/$script && echo "✓"
  sleep 0.3
done