FROM mariadb/server:10.3

COPY Skripte /home/Skripte
COPY Skripte/fuelleDatenbank_intern.sh /docker-entrypoint-initdb.d
COPY configuration /home/configuration

RUN cat /home/configuration/my.cnf >> /etc/mysql/my.cnf