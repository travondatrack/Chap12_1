# Chap12_1 - SQL Gateway Application

A Java Web Application that provides a web interface to execute SQL queries on an Aiven MySQL database.

## Features

- 🌐 Web-based SQL query interface
- 🔐 Secure connection to Aiven MySQL database
- 📊 HTML table display of query results
- 🎨 Clean, responsive UI with CSS styling
- 🔒 Environment variables for secure credential management

## Technology Stack

- **Backend**: Java Servlets, JSP
- **Database**: Aiven MySQL
- **Web Server**: Apache Tomcat 9
- **Build Tool**: Maven
- **Deployment**: Docker on Render
- **Security**: Environment variables for credentials

## Security Notice

🚨 **This application uses environment variables for database credentials. Never commit passwords or sensitive data to version control.**

## Local Development

### Prerequisites

- Docker installed
- Java 11+ (for local development)
- Maven 3.6+ (for local development)

### Build and Run with Docker

1. Clone the repository
2. Run the build script:
   ```bash
   ./build.bat
   ```
3. Run locally:
   ```bash
   docker run -p 8080:8080 chap12-1-sql-gateway
   ```
4. Visit: http://localhost:8080

## Deploy to Render

1. **Connect GitHub**: Link your repository to Render
2. **Create Web Service**: Choose "Docker" environment
3. **Configuration**:
   - Build Command: `docker build -t app .`
   - Start Command: `docker run -p $PORT:8080 app`
   - Port: 8080
4. **Deploy**: Render will automatically build and deploy

## Database Configuration

The application connects to an Aiven MySQL database with:

- Host: `mysql-3a297a68-chap12-1.i.aivencloud.com`
- Port: `27412`
- Database: `defaultdb`
- SSL: Required

## Available SQL Commands

### Query Examples:

```sql
-- Show all users
SELECT * FROM User;

-- Count users
SELECT COUNT(*) FROM User;

-- Search by name
SELECT * FROM User WHERE first_name LIKE 'J%';

-- Group by domain
SELECT SUBSTRING_INDEX(email, '@', -1) as domain, COUNT(*)
FROM User GROUP BY domain;
```

### Database Management:

```sql
SHOW TABLES;
DESCRIBE User;
SHOW DATABASES;
```

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── murach/sql/
│   │       ├── SqlGatewayServlet.java
│   │       └── SQLUtil.java
│   └── webapp/
│       ├── index.html
│       ├── styles/main.css
│       └── WEB-INF/web.xml
├── Dockerfile
├── render.yaml
└── pom.xml
```

## License

Educational Project - Free to use and modify.
