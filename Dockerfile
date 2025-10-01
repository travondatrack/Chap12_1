# Use Tomcat with JDK for compilation
FROM tomcat:9.0-jdk11-openjdk-slim

# Install gettext for envsubst
RUN apt-get update && \
    apt-get install -y gettext-base && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy source files
COPY src/java ./src/java
COPY web ./web
COPY lib ./lib

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Create directories for compilation
RUN mkdir -p WEB-INF/classes WEB-INF/lib

# Copy web content and all libraries
RUN cp -r web/* ./ && \
    cp lib/*.jar WEB-INF/lib/

# Compile Java sources using Tomcat's servlet API
RUN javac -cp "/usr/local/tomcat/lib/*:WEB-INF/lib/*" \
    -d WEB-INF/classes \
    src/java/murach/sql/*.java

# Create WAR file
RUN jar cf /usr/local/tomcat/webapps/ROOT.war *

# Copy MySQL connector to Tomcat lib
COPY lib/mysql-connector-j-9.4.0.jar /usr/local/tomcat/lib/

# Create context.xml with environment variables
RUN mkdir -p /usr/local/tomcat/conf/Catalina/localhost
COPY docker/context.xml /usr/local/tomcat/conf/Catalina/localhost/ROOT.xml

# Copy startup script
COPY docker/startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Expose port
EXPOSE 8080

# Start with custom script
CMD ["/usr/local/bin/startup.sh"]