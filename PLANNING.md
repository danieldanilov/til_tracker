# TIL Tracker App - Planning

## 🎯 Project Goal
Build a simple Ruby on Rails TIL (Today I Learned) tracker. The app serves as both a functional TIL log and a self-referential job application for a Junior Rails Programmer role at 37signals, showcasing relevant skills and values.

## 🏗️ Stack
- Ruby 3.2.2 (via rbenv)
- Rails 7+ (Current: 8.0.1)
- PostgreSQL
- TailwindCSS
- RSpec (for testing)
- FactoryBot (for test data)
- Deployment Target: Fly.io or Render

## 🗺️ Architecture & Conventions
- Standard Rails MVC structure.
- Use POROs (Plain Old Ruby Objects) if logic complexity grows beyond simple model/controller actions (e.g., for complex tag parsing if needed later).
- Adhere to 37signals Ruby/Rails style guide (provided via Cursor rules).
- Use `rbenv exec` prefix for all `rails`, `bundle`, `rake` commands due to observed shell environment inconsistencies.
- Keep controllers thin, delegate logic to models where appropriate for this simple app.
- Use `form_with` for forms.
- Use RSpec for testing (Model, Request specs primarily).
- Use I18n for user-facing strings (`config/locales/en.yml`).
- Keep files under ~300-400 lines.

## 📦 Core Features & Models

### `Til` Model
- `title:string`
- `body:text`
- `tags:string` (Comma-separated or similar simple format)
- `created_at`, `updated_at` (Default Rails timestamps)

### Controllers & Routes
- `StaticPagesController`:
    - `home` -> `/`
    - `hire_me` -> `/hire-me`
    - `about` -> `/about` (Optional)
- `TilsController`:
    - `index` -> `/tils` (List all)
    - `new` -> `/tils/new` (Show form)
    - `create` -> `POST /tils` (Save new)

## 🧪 Testing Strategy
- **Unit/Model:** `spec/models/til_spec.rb` (Validations)
- **Integration/Request:**
    - `spec/requests/static_pages_spec.rb` (Basic page rendering)
    - `spec/requests/tils_spec.rb` (Index, New, Create actions - success & failure)
- **System/Feature (Optional):** Basic test for creating a TIL via UI if time permits.

## 📚 Documentation
- `README.md`: Project summary, setup, reflection, live URL.
- `PLANNING.md` (This file): Architecture, stack, conventions, decisions.
- `TASK.md`: Detailed task breakdown and progress tracking.

## ⚙️ Key Commands & Setup Notes
- **Setup:** `cd til_tracker && rbenv exec bundle install && rbenv exec rails db:create && rbenv exec rails db:migrate`
- **Run Dev Server:** `rbenv exec bin/dev`
- **Run Tests:** `rbenv exec bundle exec rspec`
- **Rails Console:** `rbenv exec rails c`
- **DB Migrations:** `rbenv exec rails db:migrate`
- **Generate Code:** `rbenv exec rails generate ...`

## 🤔 Decisions & Considerations
- **No Auth:** Simplifies the build, focuses on core Rails skills.
- **Simple Tagging:** Using a basic string field for tags avoids complexity (e.g., adding a separate `Tag` model) for this project scope.
- **Tailwind:** Chosen for utility-first styling, common in modern Rails dev.
- **RSpec:** Specified by project rules/conventions.
- **`rbenv exec` Prefix:** Necessary due to local environment setup issues. Will document this requirement in README.

