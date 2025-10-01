# SQL Gateway Application - Render Deployment

## Prerequisites

- Docker installed locally
- Git repository
- Render account

## Environment Variables

Set these environment variables in Render:

- `DB_URL`: jdbc:mysql://34.9.114.182:3306/murach?useSSL=true&serverTimezone=UTC
- `DB_USERNAME`: murach_user
- `DB_PASSWORD`: Spk61392005@

## Local Development

### Using Docker Compose

```bash
docker-compose up --build
```

### Using Docker directly

```bash
# Build the image
docker build -t sqlgateway .

# Run with environment variables
docker run -p 8080:8080 \
  -e DB_URL="jdbc:mysql://34.9.114.182:3306/murach?useSSL=true&serverTimezone=UTC" \
  -e DB_USERNAME="murach_user" \
  -e DB_PASSWORD="Spk61392005@" \
  sqlgateway
```

## Render Deployment

### Option 1: Using render.yaml (Recommended)

1. Push code to GitHub
2. Connect repository to Render
3. Render will automatically detect `render.yaml` and deploy

### Option 2: Manual Setup

1. Create new Web Service in Render
2. Connect your GitHub repository
3. Set build command: `docker build -t sqlgateway .`
4. Set start command: `docker run -p $PORT:8080 sqlgateway`
5. Add environment variables in Render dashboard

## Database Setup

Make sure your Google Cloud SQL database has:

- Database named `murach`
- User `murach_user` with password `Spk61392005@`
- Tables created (users, etc.)

## Testing

Once deployed, test with SQL queries like:

```sql
SELECT * FROM users;
```

## Troubleshooting

- Check Render logs for connection errors
- Verify database credentials
- Ensure Google Cloud SQL allows connections from Render IPs
