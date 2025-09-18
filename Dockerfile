# Multi-stage build for Java Web App
FROM maven:3.8.6-openjdk-11 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml first for better caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM tomcat:9.0-jdk11-openjdk

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file to Tomcat webapps
COPY --from=build /app/target/Chap12_1-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port (Render will use this)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]