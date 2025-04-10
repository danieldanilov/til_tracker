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
    # Reason: Use rbenv exec for consistency, avoids potential shell issues
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
  rbenv exec bin/dev
  ```
  Visit `http://localhost:3000` in your browser.

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
