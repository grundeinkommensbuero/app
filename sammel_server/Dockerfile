FROM jboss/wildfly

# Datenbank-Connector als Modul kopieren
COPY Wildfly/mariaDB /opt/jboss/wildfly/modules/org/mariadb/main

# Configuration kopieren
COPY Wildfly/configuration /opt/jboss/wildfly/standalone/configuration/
COPY Wildfly/bin /opt/jboss/wildfly/bin/

# Artefakte zum Deployment kopieren
COPY target/*.war /opt/jboss/wildfly/standalone/deployments/

COPY Wildfly/start_wildfly_after_db.sh /opt/jboss/wildfly/start_wildfly_after_db.sh

# Richte Standard-Admin-Nutzer ein
RUN /opt/jboss/wildfly/bin/add-user.sh admin password --silent

# Warte bis Datenbank gestartet wurde
# und dann Wildfly nochmal neu starten, diesmal mit Admin-Port der auch außerhalb von 127.0.0.1 zugänglich ist
CMD /opt/jboss/wildfly/start_wildfly_after_db.sh $DB_URL $DB_PORT $DB_SCHEMA $DB_USER $DB_PASSWORD $STORE_NAME $STORE_PASSWORD
#CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]

# Console Port
EXPOSE 9990
EXPOSE 8787