# Santa Present API

💧 A Vapor web application for managing gift tracking with PostgreSQL database.

## Features

- RESTful API for managing gifts
- PostgreSQL database with Fluent ORM
- Docker support for containerized deployment
- Heroku deployment ready

## Tech Stack

- **Framework**: Vapor 4
- **Language**: Swift 6.1
- **Database**: PostgreSQL with Fluent
- **Deployment**: Docker, Heroku

## API Endpoints

- `GET /` - Health check endpoint
- `GET /gifts` - Get all gifts
- `POST /gifts` - Create a new gift
- `GET /gifts/:id` - Get a specific gift
- `DELETE /gifts/:id` - Delete a gift

## Local Development

### Prerequisites

- Swift 6.1 or later
- PostgreSQL 14 or later
- Docker (optional)

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd hello
```

2. Copy the example environment file:
```bash
cp .env.example .env
```

3. Configure your database settings in `.env`:
```env
DATABASE_USERNAME=your_username
DATABASE_PASSWORD=your_password
DATABASE_NAME=your_database
```

4. Build and run:
```bash
swift build
swift run
```

The server will start on `http://localhost:8080`

### Using Docker

Run with Docker Compose:
```bash
docker-compose up
```

## Deployment

### Heroku

This application is configured for Heroku deployment using Docker.

1. Install Heroku CLI and login:
```bash
heroku login
```

2. Create a Heroku app:
```bash
heroku create your-app-name
```

3. Add PostgreSQL addon:
```bash
heroku addons:create heroku-postgresql:essential-0
```

4. Deploy:
```bash
git push heroku master
```

The application will automatically build using the Dockerfile and deploy.

**Live Demo**: https://santa-present-f395b2e91f52.herokuapp.com/

## Testing

Run tests with:
```bash
swift test
```

## Project Structure

- `Sources/hello/` - Application source code
  - `configure.swift` - Application configuration
  - `routes.swift` - Route definitions
  - `Models/` - Database models
  - `Migrations/` - Database migrations
- `Tests/` - Test files
- `Public/` - Static files
- `Dockerfile` - Docker configuration
- `docker-compose.yml` - Docker Compose configuration
- `heroku.yml` - Heroku deployment configuration

## Environment Variables

- `DATABASE_URL` - PostgreSQL connection URL (set automatically by Heroku)
- `LOG_LEVEL` - Logging level (debug, info, warning, error)
- `PORT` - Server port (set automatically by Heroku)

## See More

- [Vapor Website](https://vapor.codes)
- [Vapor Documentation](https://docs.vapor.codes)
- [Vapor GitHub](https://github.com/vapor)
- [Vapor Community](https://github.com/vapor-community)
