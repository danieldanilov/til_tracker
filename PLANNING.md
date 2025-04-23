# TIL Tracker App - Planning

## 🎯 Project Goal
Build a simple Ruby on Rails TIL (Today I Learned) tracker. The app serves as both a functional TIL log and a self-referential job application for a Junior Rails Programmer role at 37signals, showcasing relevant skills and values.

**Note:** The project root directory is `til_tracker` within the workspace. All paths mentioned should be considered relative to this directory.

## 🏗️ Stack
- Ruby 3.2.2 (via rbenv)
- Rails 7+ (Current: 8.0.1)
- PostgreSQL
- **Hand-crafted CSS** (No CSS Frameworks)
- RSpec (for testing)
- FactoryBot (for test data)
- Deployment Target: Fly.io or Render

## 🗺️ Architecture & Conventions
- Standard Rails MVC structure. **Removed default directories**: `app/jobs`, `app/mailers`, `app/helpers`, `app/controllers/concerns`, `vendor`, `script`, `storage`.
- **Removed configuration**: `.kamal`, `.github`, `Dockerfile`, `.dockerignore`, `.rubocop.yml`.
- **Note:** `.github/workflows/ci.yml` exists for basic linting and security checks.
- **Note:** `rubocop-rails-omakase` is included for linting (see `Gemfile`).
- Use POROs (Plain Old Ruby Objects) if logic complexity grows beyond simple model/controller actions (e.g., for complex tag parsing if needed later).
- Adhere to 37signals Ruby/Rails style guide (provided via Cursor rules).
- Use `rbenv exec` prefix for all `rails`, `bundle`, `rake` commands due to observed shell environment inconsistencies. *See Key Commands & Learnings*.
- Keep controllers thin, delegate logic to models where appropriate for this simple app.
- Use `form_with` for forms.
- **Use Hotwire (Turbo/Stimulus) for interactivity.**
- **Write simple, semantic, hand-crafted CSS.** Use `app/assets/stylesheets/application.css` and potentially component-specific files if needed. Avoid complex selectors or large stylesheets.
- Use RSpec for testing (Model, Request specs primarily).
- Use I18n for user-facing strings (`config/locales/en.yml`).
- Keep files under ~300-400 lines.
- **Learning Logs:** Entries in `LEARNINGS.md` and `db/seeds.rb` should be written from my perspective (first-person: "I", "my", "me").

## 📦 Core Features & Models

### `Learning` Model
- `title:string`
- `body:text`
- `tags:string` (Comma-separated or similar simple format)
- `learned_on:date` (Date the learning actually occurred, defaults to creation date)
- `created_at`, `updated_at` (Default Rails timestamps)

### Controllers & Routes
- `StaticPagesController`:
    - `home` -> `/`
    - `hire_me` -> `/hire-me`
    - `about` -> `/about` (Optional)
- `LearningsController`:
    - `index` -> `/learnings` (List all, sorted by `learned_on` desc)
    - `new` -> `/learnings/new` (Show form)
    - `create` -> `POST /learnings` (Save new)
    - `destroy_multiple` -> `DELETE /learnings/multiple` (Delete selected)

## 🧪 Testing Strategy
- **Unit/Model:** `spec/models/learning_spec.rb` (Validations)
- **Integration/Request:**
    - `spec/requests/static_pages_spec.rb` (Basic page rendering - Uses path helpers like `root_path`)
    - `spec/requests/learnings_spec.rb` (Index, New, Create, Destroy Multiple actions - success & failure, Tag filtering)
- **System/Feature (Optional):** Basic test for creating a Learning via UI if time permits.
- **Testing Gems:**
    - `rspec-rails` (Core)
    - `factory_bot_rails` (For test data generation)
    - `rails-controller-testing` (For `render_template` matcher)

## 📚 Documentation
- `README.md`: Project summary, setup, reflection, live URL.
- `PLANNING.md` (This file): Architecture, stack, conventions, decisions.
- `TASK.md`: Detailed task breakdown and progress tracking.
- `LEARNINGS.md`: Log of issues, solutions, and learnings (written in first person).

## ⚙️ Key Commands & Setup Notes
- **Setup:** `cd til_tracker && rbenv exec bundle install && rbenv exec rails db:create && rbenv exec rails db:migrate`
- **Run Dev Server:** `bin/dev` or `rbenv exec bin/dev` (Use `./bin/dev` if `rbenv exec` fails - see Learnings).
- **Run Tests:** `rbenv exec bundle exec rspec`
- **Fix Code Style (Locally):** `rbenv exec bundle exec rubocop -A` (Run this if CI lint check fails)
- **Rails Console:** `rbenv exec rails c`
- **DB Migrations:** `rbenv exec rails db:migrate`
- **Generate Code:** `rbenv exec rails generate ...`
- **Install Bundler:** `gem install bundler -v <version_from_gemfile_lock>` (If needed due to environment issues)

## 🤔 Decisions & Considerations
- **No Auth:** Simplifies the build, focuses on core Rails skills.
- **Simple Tagging:** Using a basic string field for tags avoids complexity (e.g., adding a separate `Tag` model) for this project scope.
- **No CSS Framework:** Per 37signals rules, Tailwind (or any framework) is disallowed. We will use minimal, hand-crafted CSS.
- **RSpec:** Specified by project rules/conventions.
- **`rbenv exec` Prefix:** Recommended due to local environment setup issues observed. However, `bin/dev` might work without it if shims are correctly configured. Document this requirement/caveat in README.
- **Hotwire:** Standard for 37signals-style development, provides interactivity without heavy JS frameworks.
- **Learning Selection UI:** Using CSS-only selectable boxes instead of traditional checkboxes for better aesthetics while maintaining functionality. Follows 37signals' preference for clean, minimal UI patterns. (Added Apr 12, 2025)
- **Project Cleanup (Apr 13, 2024):** Removed unused directories (`jobs`, `mailers`, `helpers`, `concerns`, `vendor`, `script`, `storage`), configurations (`.kamal`, `.github`, `Dockerfile`, `.dockerignore`, `.rubocop.yml`), and gems (`solid_queue`, `solid_cable`, `jbuilder`, `kamal`, `rubocop-rails-omakase`) to align with minimal 37signals philosophy.
- **Retroactive Logging (Apr 13, 2024):** Added a `learned_on` date field to allow logging past learnings. Defaults to the creation date for simplicity when logging current items. Sorting changed to use this field.
- **CI Fixes (Apr 14, 2024):** Re-added `rubocop-rails-omakase` to `Gemfile` and corrected the `importmap:audit` command in `.github/workflows/ci.yml` to fix CI build failures.
- **Code Style Enforcement (Apr 14, 2024):** Configured the GitHub Actions CI workflow (`.github/workflows/ci.yml`) to automatically fail builds if `bundle exec rubocop` detects style violations. Developers should run `rbenv exec bundle exec rubocop -A` locally to fix identified issues before committing.
- **Importmap Audit Removal (Apr 14, 2024):** Removed the `scan_js` job (which attempted to run `importmap:audit`) from the CI workflow. The `importmap:audit` task was found to be unavailable in the current Rails/importmap-rails setup, and the job was removed to simplify CI and eliminate the persistent failure.
- **Tag Filtering (Apr 14, 2024):** Decided to enhance the existing `tags:string` field by implementing simple, clickable tag filtering on the index page using Turbo Frames. This adds organizational value and demonstrates core Rails/Hotwire skills without overcomplicating the tagging mechanism (e.g., avoiding separate Tag models for now).
- **Testing Dependencies (Apr 14, 2024):** Added `factory_bot_rails` for efficient test data creation and `rails-controller-testing` to enable the `render_template` RSpec matcher after it was extracted from Rails core.
- **Static Page Specs (Apr 14, 2024):** Updated static page request specs to use Rails path helpers (`root_path`, `hire_me_path`, etc.) instead of hardcoded paths to fix 404 errors in tests.
- **Render Deployment (Apr 14, 2024):** Chose Render as the deployment platform. Required switching from "Static Site" to "Web Service" type. Configuration involved setting Build Command (`bundle install; ... assets:precompile; ... assets:clean`), Start Command (`bundle exec puma -C config/puma.rb`), and ensuring `RAILS_ENV`/`RACK_ENV` were set to `production`. `DATABASE_URL` needed to be explicitly added/linked from the Render PostgreSQL service as it wasn't automatically added. Initial migrations required adding `bundle exec rails db:migrate` to the Build Command temporarily (due to lack of shell access/pre-deploy command on free tier).
- **Delete Button Enhancement (Apr 19, 2024):** Moved the "Delete Selected" button to the top left of the learnings list page next to the "Log New Learning" button. An attempt to use Stimulus to dynamically enable/disable the button based on selection was reverted due to persistent JavaScript execution issues.
- **Form UI/UX Refinement (Apr 19, 2024):** Improved the new/edit learning form using standard Rails helpers (`_form.html.erb` partial), hand-crafted CSS (`application.css`), and HTML attributes (`placeholder`). Focused on clear guidance, consistent spacing/fonts, and alignment with index page layout. Addressed CSS caching/asset pipeline issues during development.
- **Native Date Field (Apr 19, 2024):** Decided to retain the standard HTML5 `date_field` despite browser UI inconsistencies, prioritizing simplicity and avoiding JavaScript date pickers. Added format hint `(YYYY-MM-DD)` to the label.
- **Production Data Seeding (Apr 20, 2024):** Decided to use the project's `.cursor/rules/LEARNINGS.md` file as the source for initial production data. A script was generated to parse this file and populate `db/seeds.rb` using an idempotent `Learning.find_or_create_by!` approach. This allows transferring the development journey log into the live application.
- **Writing Samples Page (Apr 20, 2024):** Added a new static page `/writing-samples` using `StaticPagesController#writing_samples`. Content is sourced from `.cursor/rules/37signals.md` to showcase relevant writing examples.
- **PDF Handling (Apr 22, 2024):** Placed CV and Cover Letter PDFs in `public/documents/` for simple download links via standard HTML `<a>` tags. Enabled static file serving in development (`config/environments/development.rb`) to allow local access. Edited PDF metadata (`Title`) externally to control browser tab display name.
- **Hire Me Page Content (Apr 22, 2024):** Revised content strategy to be honest about limited professional Rails experience, framing the TIL Tracker app itself as a demonstration of rapid learning, alignment with 37signals values, and potential.
- **Email Link (Apr 22, 2024):** Decided to use the Rails `mail_to` helper for the contact email on the Hire Me page for better usability.
- **Navigation Order (Apr 22, 2024):** Reordered main navigation links to Learnings > New Learning > About The App > Hire Me > Writing Samples for improved logical flow.
- **Production Seeding Issues (Apr 23, 2024):** Encountered issues where standard `db:seed` (using `find_or_create_by!`) in Render's Pre-Deploy command didn't update existing records reliably after seed file changes. Attempts to use `db:reset` failed due to database connections and lack of SUPERUSER privileges. A temporary workaround using `DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:seed:replant` in Pre-Deploy forced a reset. The Pre-Deploy command was reverted to the standard idempotent `bundle exec rails db:migrate; bundle exec rake db:seed` for ongoing deploys.
- **Learning Log Perspective (Apr 23, 2024):** Decided that all learning log entries (`LEARNINGS.md` and `db/seeds.rb`) should be written in the first person ("I", "my", "me") to maintain a personal voice.

