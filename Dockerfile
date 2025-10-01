# Multi-stage build
FROM openjdk:11-jdk-slim as builder

# Install Ant and wget
RUN apt-get update && \
    apt-get install -y ant wget && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy source code
COPY . .

# Download MySQL Connector/J if not present
RUN if [ ! -f "lib/mysql-connector-j-9.4.0.jar" ]; then \
        mkdir -p lib && \
        wget -O lib/mysql-connector-j-9.4.0.jar \
        https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.4.0/mysql-connector-j-9.4.0.jar; \
    fi

# Build the application
RUN ant clean && ant

# Production stage
FROM tomcat:9.0-jdk11-openjdk-slim

# Install envsubst for environment variable substitution
RUN apt-get update && \
    apt-get install -y gettext-base && \
    rm -rf /var/lib/apt/lists/*

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file
COPY --from=builder /app/dist/ch12_ex1_sqlGateway.war /usr/local/tomcat/webapps/ROOT.war

# Copy MySQL connector to Tomcat lib
COPY --from=builder /app/lib/mysql-connector-j-9.4.0.jar /usr/local/tomcat/lib/

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