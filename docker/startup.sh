#!/bin/bash

# Replace environment variables in context.xml
envsubst '${DB_URL} ${DB_USERNAME} ${DB_PASSWORD}' < /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml > /tmp/context.xml
mv /tmp/context.xml /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

# Start Tomcat
exec catalina.sh run