# SQL Gateway Application - Render Deployment

## Prerequisites

- Docker installed locally
- Git repository
- Render account

## Environment Variables

Set these environment variables in Render Dashboard (not in code):

- `DB_URL`: Your database connection URL
- `DB_USERNAME`: Your database username
- `DB_PASSWORD`: Your database password

## Local Development

### Using Docker Compose

```bash
docker-compose up --build
```

### Using Docker directly

```bash
# Build the image
docker build -t sqlgateway .

# Run with environment variables (set your own values)
docker run -p 8080:8080 \
  -e DB_URL="your_database_url" \
  -e DB_USERNAME="your_username" \
  -e DB_PASSWORD="your_password" \
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

Make sure your database has:

- Database named `murach` (or your preferred name)
- A user with appropriate permissions
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
