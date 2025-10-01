#!/bin/bash

# Create lib directory if it doesn't exist
mkdir -p lib

# Download MySQL Connector/J if not present
if [ ! -f "lib/mysql-connector-j-9.4.0.jar" ]; then
    echo "Downloading MySQL Connector/J 9.4.0..."
    curl -L -o lib/mysql-connector-j-9.4.0.jar \
        https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.4.0/mysql-connector-j-9.4.0.jar
    echo "Download completed."
else
    echo "MySQL Connector/J already exists."
fi