# Music Practice Journal

A Rails application for tracking music practice, like a practice journal.

**⚠️ This is a work in progress project used for testing Rails features and other tools 👷 🧪**

Includes both a **web UI** and **REST API** for CRUD operations.

## Domain Schema
<image width='300px' src='erd.svg'>

## Tech Stack
- **Ruby 3.3.10** | **Rails 8.1** | **PostgreSQL**
- Authentication: Devise + JWT
- Authorization: Pundit
- Asset Pipeline: Propshaft
- Styling: Tailwind CSS 2.0
- Testing: RSpec 6.0 + FactoryBot + Shoulda::Matchers
- Linting: Rubocop (100 char line length)

## Setup & Running

### With Docker (Recommended)
```bash
docker-compose up
```
This starts:
- PostgreSQL on port 5433
- Rails APP on port 3000

Run tests:
```bash
docker-compose exec app bundle exec rspec
```

### Local Setup (Requires Ruby 3.3.10 + PostgreSQL)
```bash
bin/setup              # Install dependencies & prepare database
bin/dev                # Start development server with Foreman
bin/rails s            # Start Rails server on port 3000
bundle exec rspec      # Run tests
bundle exec rubocop    # Lint check
```

## API & Web Routes
- **Web routes** (`/web`): View interface for CRUD operations
  - `GET /web/musics` → list musics
  - `GET /web/practice_sessions` → list practice sessions
  - Full CRUD available for both resources

- **API routes** (`/api/v1`): JSON endpoints (legacy)
  - `POST /api/v1/register` → create user (no auth required)
  - `POST /api/v1/login` → issue JWT token
  - CRUD resources: musics, practice_sessions (all require auth)

## Dependencies

### Docker Setup
- Docker
- Docker Compose

### Local Setup
- Ruby 3.3.10
- PostgreSQL
- Bundler

## Development Scripts
- `bin/setup` - Initialize development environment
- `bin/dev` - Start dev server with hot-reload
- `bin/rails` - Run Rails commands