@echo off
echo Building Docker image for Chap12_1...

REM Build Docker image
docker build -t chap12-1-sql-gateway .

REM Check if build was successful
if %errorlevel% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo Build successful!
echo.
echo To run locally with environment variables:
echo docker run -p 8080:8080 ^
echo   -e DATABASE_URL="jdbc:mysql://your-host:port/database?ssl-mode=REQUIRED&serverTimezone=UTC" ^
echo   -e DATABASE_USERNAME="your-username" ^
echo   -e DATABASE_PASSWORD="your-password" ^
echo   chap12-1-sql-gateway
echo.
echo Then visit: http://localhost:8080
echo.
echo NOTE: Set your actual database credentials in the environment variables above!
pause