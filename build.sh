#!/bin/bash

echo "Starting manual build process..."

# Create build directories
mkdir -p build/web/WEB-INF/classes
mkdir -p build/web/WEB-INF/lib
mkdir -p dist

# Download servlet API if not present
if [ ! -f "lib/servlet-api.jar" ]; then
    echo "Downloading servlet API..."
    wget -O lib/servlet-api.jar https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar
fi

# Copy web files
echo "Copying web files..."
cp -r web/* build/web/

# Copy libraries
echo "Copying libraries..."
cp lib/mysql-connector-j-9.4.0.jar build/web/WEB-INF/lib/

# Compile Java sources with servlet API in classpath
echo "Compiling Java sources..."
javac -cp "lib/*:build/web/WEB-INF/lib/*" -d build/web/WEB-INF/classes src/java/murach/sql/*.java

if [ $? -eq 0 ]; then
    echo "Compilation successful"
    
    # Create WAR file
    echo "Creating WAR file..."
    cd build/web
    jar cf ../../dist/ch12_ex1_sqlGateway.war *
    cd ../..
    
    echo "Build completed successfully!"
    ls -la dist/
else
    echo "Compilation failed!"
    exit 1
fi