# TIL Tracker

This is a simple "Today I Learned" (TIL) tracker application built with Ruby on Rails, following the 37signals development philosophy (minimal JS, server-rendered HTML, hand-crafted CSS).

It also serves as a self-referential job application, demonstrating core Rails skills.

## Ruby Version

- Ruby 3.2.2 (Managed via `rbenv`)

## System Dependencies

- PostgreSQL
- `rbenv` (or similar Ruby version manager)
- Bundler

## Setup

1.  **Clone the repository:**
    ```bash
    git clone [repository-url]
    cd ruby-app-37s/til_tracker
    ```
2.  **Ensure correct Ruby version:**
    ```bash
    rbenv install 3.2.2 # If not already installed
    rbenv local 3.2.2
    ```
3.  **Install dependencies:**
    ```bash
    # Reason: Use rbenv exec for consistency, avoids potential shell issues with gem installation
    rbenv exec bundle install
    ```
4.  **Create and migrate the database:**
    ```bash
    rbenv exec rails db:create
    rbenv exec rails db:migrate
    ```

## Running the Application

- **Start the development server:**
  ```bash
  # Reason: Use ./bin/dev directly. `rbenv exec bin/dev` may fail due to shell/rbenv path issues.
  ./bin/dev
  ```
  The server typically runs on `http://localhost:3000` by default.

  If port 3000 is in use, you can specify a different port using the `PORT` environment variable:
  ```bash
  PORT=8000 ./bin/dev
  ```
  Then visit `http://localhost:8000` (or your chosen port).

## Running Tests

- **Execute the RSpec test suite:**
  ```bash
  rbenv exec bundle exec rspec
  ```

## Key Design Choices

- **No Frontend Framework:** Uses Hotwire (Turbo/Stimulus) for interactivity.
- **No CSS Framework:** Uses simple, hand-crafted CSS (`app/assets/stylesheets/application.css`).
- **Simple Tagging:** Uses a basic string field for tags to maintain simplicity.
- **No Authentication:** Focuses on core CRUD functionality.

## Deployment

This application is deployed on Render.

**Live URL:** [https://til-tracker.onrender.com/](https://til-tracker.onrender.com/)

*(Note: The free tier may cause the application to spin down after inactivity, resulting in a short delay on the first visit.)*
