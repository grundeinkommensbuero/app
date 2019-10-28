FROM jboss/wildfly

# Datenbank-Connector als Modul kopieren
COPY Wildfly/mySQL /opt/jboss/wildfly/modules/com/mysql/main

# Configuration kopieren
COPY Wildfly/configuration /opt/jboss/wildfly/standalone/configuration/

# Artefakte zum Deployment kopieren
COPY target/*.war /opt/jboss/wildfly/standalone/deployments/

# Richte Standard-Admin-Nutzer ein
RUN /opt/jboss/wildfly/bin/add-user.sh admin password --silent

# Wildfly nochmal neu starten, diesmal mit Admin-Port der auch außerhalb von 127.0.0.1 zugänglich ist
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]

# Console Port
EXPOSE 9990