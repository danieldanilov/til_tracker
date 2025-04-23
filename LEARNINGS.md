# Learnings & Issues Log

This file tracks issues I encountered, solutions I applied, and general learnings during the development of the TIL Tracker app.

**Convention:** All entries should be written from my perspective (first person: "I", "my", "me").

## Session: Apr 8, 2024

1.  Issue: `rbenv: bin/dev: command not found` when I used `rbenv exec bin/dev`.
    *   Context: I was attempting to start the Rails development server using the project's specified command style (`rbenv exec ...`).
    *   Resolution: I found that running `./bin/dev` directly works correctly. The script's shebang (`#!/usr/bin/env ruby`) combined with my existing `rbenv` shim setup ensures the correct Ruby version is used without needing the `rbenv exec` prefix for this specific script. The prefix was causing an execution issue.
    *   Learning: I learned that `rbenv exec` might not always be necessary or beneficial if the target script and my shell environment (shims, PATH) are already correctly configured to find the intended Ruby version. In some cases, it can interfere. I updated the project convention in `PLANNING.md` to note this specific case might not require the prefix.

2.  Issue: Rails generator failed for model name `Til` (`The name 'Til' is either already used...`).
    *   Context: I was trying to generate the primary model for the application as `Til`.
    *   Resolution: I switched to using the name `Learning` for the model and `LearningsController` for the associated controller. I generated these components successfully and removed the previous partially generated/conflicting `Til` files and migration. I updated `TASK.md` and `routes.rb` accordingly.
    *   Learning: I learned to be aware of potential naming collisions with Rails internals or reserved words, even if not strictly listed. Choosing a slightly more descriptive or different name can avoid generator issues.

3.  Issue: Rails generator failed for `StaticPagesController` due to name collision.
    *   Context: I was attempting to generate `StaticPagesController` as per `TASK.md`.
    *   Resolution: I realized the controller already existed (likely from initial `rails new` or prior steps). I verified the existing controller contained the necessary actions (`home`, `hire_me`, `about`).
    *   Learning: I learned to confirm whether components exist before running generators, especially when resuming work or working from a task list, to avoid simple errors.

## Session: Apr 9, 2024

1.  Issue: Initial confusion about the project root directory.
    *   Context: Cursor initially looked for files in the workspace root (`/Users/danildanilov/Documents/GitHub/ruby-app-37s`) instead of my project directory (`/Users/danildanilov/Documents/GitHub/ruby-app-37s/til_tracker`).
    *   Resolution: I clarified the correct path. I added a note to `PLANNING.md` specifying `til_tracker` as the project root.
    *   Learning: I learned to always confirm the project's subdirectory structure within the workspace, especially if not at the top level, and update planning docs accordingly.

2.  Issue: `NoMethodError: undefined method 'pluralize' for #<LearningsController:...>` when deleting learnings.
    *   Context: The `destroy_multiple` action in `LearningsController` tried to use the `pluralize` helper directly.
    *   Resolution: I changed the call to `view_context.pluralize` to access the view helper from the controller.
    *   Learning: I learned that view helpers like `pluralize` are part of `ActionView` and must be accessed via `view_context` when called from within a controller.

3.  Issue: `brew services start postgresql` failed (`Formula 'postgresql@14' is not installed`).
    *   Context: I was trying to start the database service required by the Rails app.
    *   Resolution: I installed PostgreSQL using `brew install postgresql`, then started the specific versioned service with `brew services start postgresql@14`.
    *   Learning: I learned to ensure required background services (like databases) are installed via the package manager (Homebrew) before attempting to start them. I also need to verify the correct formula name if using versioned formulas.

4.  Issue: `bundle install` failed (`Could not locate Gemfile`).
    *   Context: I ran `bundle install` from the parent directory (`ruby-app-37s`) instead of the project root.
    *   Resolution: I changed directory to `til_tracker` before running `bundle install`.
    *   Learning: I learned to always run commands like `bundle install` or `rails` from the root directory of the specific Rails project.

5.  Issue: `bundle install` failed (`Could not find 'bundler' (2.6.7) required by ... Gemfile.lock`).
    *   Context: The Ruby version active in my shell (initially system Ruby 2.6) did not have the specific `bundler` gem version required by the project installed.
    *   My Attempt: `gem install bundler:2.6.7`.
    *   Learning: Projects lock specific bundler versions in `Gemfile.lock`. My active Ruby environment must have this bundler version installed.

6.  Issue: `gem install bundler:2.6.7` failed (`Gem::FilePermissionError` for `/Library/Ruby/Gems/2.6.0`).
    *   Context: My shell was using the system Ruby (2.6.x), and installing gems globally requires permissions and is generally discouraged. My project's `.ruby-version` specified 3.2.2.
    *   Resolution: I identified that `rbenv` was installed but not properly activated in my shell environment (`PATH` configuration issue in `.zshrc`).
    *   Learning: I learned to use a Ruby version manager (`rbenv`) to handle project-specific Ruby versions and avoid modifying the system Ruby installation. I need to ensure the version manager is correctly initialized in my shell configuration (`.zshrc`).

7.  Issue: `rbenv` installed but not activating correctly (`ruby -v` showed system Ruby, `which gem` showed system gem).
    *   Context: The `rbenv init` command in my `.zshrc` was not correctly modifying the `PATH` to prioritize `rbenv` shims, potentially due to conflicts or ordering issues within the `.zshrc` file.
    *   Resolution (Temporary): I manually prepended the shims directory for the current session: `export PATH="$HOME/.rbenv/shims:$PATH"`.
    *   Resolution (Workaround): I followed the `PLANNING.md` convention of using `rbenv exec` before `bundle` and `rails` commands (e.g., `rbenv exec bundle install`, `rbenv exec rails db:create`).
    *   Resolution (Permanent Fix Needed): My `.zshrc` still requires investigation to ensure `rbenv init` works correctly on shell startup.
    *   Learning: Correct shell integration is crucial for `rbenv`. I learned to check `PATH` and `.zshrc` initialization order if versions aren't switching automatically. `rbenv exec` is a reliable workaround if shell integration is problematic.

8.  Issue: `rbenv exec bin/dev` failed initially.
    *   Context: I ran the command from the wrong directory and `bin/dev` potentially lacked execute permissions.
    *   Resolution: I added execute permissions (`chmod +x til_tracker/bin/dev`), changed to the `til_tracker` directory, and reran `rbenv exec bin/dev`.
    *   Learning: I learned to ensure scripts have necessary permissions (`+x`) and are executed from the correct working directory relative to the project structure.

9.  Issue: `rails new` failed during initial `bundle install` (`ERROR: Failed to build gem native extension.` for `pg` gem).
    *   Context: The `pg` gem requires the PostgreSQL client library (`libpq`) to build its native C extension.
    *   Resolution: I installed the client library using `brew install libpq`.
    *   Learning: Native extensions for gems often depend on external system libraries. I learned to read the error messages carefully, as they usually suggest the required package and installation command (e.g., via Homebrew).

10. Issue: Subsequent `bundle install` failed (`Could not find 'bundler' (2.6.7) ...`).
    *   Context: Even after installing `libpq`, my shell was still trying to use the system Ruby's environment/bundler version, indicating `rbenv` wasn't fully integrated/activated for the `bundle` command execution.
    *   My Attempt: `gem install bundler` directly, which failed with `Gem::FilePermissionError` (again trying to use system Ruby gems location).
    *   Learning: Persistent environment issues suggest deeper problems with my shell initialization (`.zshrc`) or PATH order. I verified my `rbenv` path was missing.

11. Issue: `rbenv` PATH missing, `gem install bundler` still fails with permission error.
    *   Context: `rbenv init` in my `.zshrc` was likely placed incorrectly, preventing shims from being added to the PATH early enough.
    *   Resolution (Workaround): I used `rbenv exec gem install bundler` to successfully install bundler within the correct Ruby 3.2.2 context.
    *   Learning: `rbenv exec` forces the command to run within the context of the selected `rbenv` version, bypassing potential PATH or shell integration issues. It's a reliable way to ensure the correct Ruby environment is used.

12. Issue: `rbenv exec bundle install` failed again on `pg` gem build (`Can't find the 'libpq-fe.h' header`).
    *   Context: Although I had installed `libpq` via Homebrew, the build process (even when run via `rbenv exec`) didn't know where to find the necessary header files and libraries.
    *   Resolution: I explicitly configured Bundler to tell the `pg` gem build process where to find the Homebrew `libpq` installation using `rbenv exec bundle config build.pg --with-pg-config=/opt/homebrew/opt/libpq/bin/pg_config`, followed by `rbenv exec bundle install`.
    *   Learning: For gems with native extensions that depend on external libraries installed in non-standard locations (like Homebrew on Apple Silicon), I learned I may need to provide explicit configuration hints to the build process using `bundle config build.<gem_name> --with-<config-option>=/path/to/dependency`.

13. Issue: `rbenv exec rails db:create` failed (`ActiveRecord::ConnectionNotEstablished`).
    *   Context: The PostgreSQL server was not running or accessible.
    *   Resolution: I started the PostgreSQL service (e.g., `brew services start postgresql`).
    *   Learning: I learned to ensure required background services like databases are running before Rails attempts to connect to them.

## Session: Apr 12, 2024

1.  Issue: UI alignment issues with learning items - checkboxes and titles not aligned.
    *   Context: When displaying learning items in the index view, the selection checkbox and title were misaligned, with the title appearing below the checkbox.
    *   Resolution: I implemented a CSS-only selectable box pattern using hidden checkboxes and custom indicators, along with careful flex alignment and margin adjustments to ensure consistent layout.
    *   Learning: Pure CSS solutions can often replace JavaScript for simple interactions. I learned that using the `<label>` element wrapping a checkbox creates native toggle behavior without needing JavaScript. CSS selectors like `:checked + .element` enable styling based on input states.

2.  Issue: Traditional checkboxes looked out of place in the 37signals-style UI.
    *   Context: The default browser checkboxes were not aligned with the clean, minimal aesthetic I desired for the application.
    *   Resolution: I created custom selection indicators using CSS, with different styling for unselected, hover, and selected states. I used a circular indicator with a checkmark that appears when selected.
    *   Learning: I learned that custom form controls can be built using the combination of visually hidden native inputs (for accessibility and functionality) paired with styled pseudo-elements for visual presentation. This maintains all native browser behaviors while allowing complete visual customization.

## Session: Apr 13, 2024

*(Cleanup & Environment Issues)*

1.  What I Did: Performed project cleanup to align with 37signals minimal approach.
    *   Details: I identified and removed standard Rails directories/files not actively used: `app/jobs/`, `app/mailers/`, `app/helpers/`, `app/controllers/concerns/`, `vendor/`, `script/`, `storage/`, corresponding `spec/helpers/` files.
    *   Details: I removed configuration files for unused tools/services: `.kamal/`, `.github/`, `Dockerfile`, `.dockerignore`, `.rubocop.yml`.
    *   Details: I removed default Rails icons from `public/`.
    *   Learning: I learned to regularly review default Rails structure and remove components not essential to the application's core functionality to maintain simplicity.

2.  What I Did: Reviewed `Gemfile` and removed unused gems.
    *   Details: I identified and removed `solid_queue` (no jobs), `solid_cable` (no Action Cable), `jbuilder` (no JSON API), `kamal` (not deployment target), `rubocop-rails-omakase` (no active linting).
    *   Learning: I learned to keep `Gemfile` lean by removing dependencies that aren't actively used. Run `bundle install` after changes.

3.  Issue: `bundle install` failed (`Could not find 'bundler' (2.6.7)...`).
    *   Context: My shell environment was attempting to use system Ruby's bundler, not the one associated with my project's `rbenv` version (3.2.2), and the required version (2.6.7) wasn't installed for the active Ruby.
    *   My Attempt: `gem install bundler:2.6.7`.
    *   Learning: `Gemfile.lock` dictates the required Bundler version. I learned to ensure this version is installed *for the correct, active Ruby version* managed by `rbenv` (or similar).

4.  Issue: `gem install bundler:2.6.7` failed (`Gem::FilePermissionError`).
    *   Context: The command was still running in the context of the system Ruby, attempting to write to protected system directories (`/Library/Ruby/Gems/2.6.0`).
    *   Resolution: I had to ensure my terminal session correctly activated the `rbenv` Ruby version (3.2.2) *before* running `gem install bundler -v 2.6.7` and subsequent `bundle install`.
    *   Learning: Persistent permission errors during `gem install` strongly indicate the wrong Ruby environment is active. I learned to verify my `rbenv` (or similar) setup and activation (`ruby -v`, `which ruby`, `which gem`). Using `rbenv exec gem install ...` can sometimes bypass activation issues but doesn't fix underlying environment problems.

5.  Issue: `rbenv exec bin/dev` failed (`rbenv: bin/dev: command not found`).
    *   Context: Attempting to start the server using the previously established convention after cleanup and `bundle install`.
    *   My Observation: This repeats a similar issue from Apr 8. The `bin/dev` script itself likely works fine when I execute it directly (`./bin/dev`) if my `PATH` includes the `rbenv` shims correctly.
    *   Learning: The need for `rbenv exec` seems inconsistent, particularly with binstubs like `bin/dev`. This likely points to subtle issues in my shell's `rbenv init` configuration or `PATH` setup. While `rbenv exec` is a workaround for `rails`, `bundle`, `rake`, it might interfere with correctly shimmed binstubs. I decided to recommend `./bin/dev` as a fallback if `rbenv exec bin/dev` fails.

*(Feature Implementation & Fix)*

6.  Feature: I implemented retroactive learning logging.
    *   Details: I added `learned_on` date field to `Learning` model/migration (non-null, default `CURRENT_DATE`), updated controller `learning_params` and `index` sorting, added `date_field` to `new` form, updated `index` view display.
    *   Learning: I learned that using SQL default `CURRENT_DATE` is effective for database-level defaults, but `Date.today` is needed for setting defaults in the view for new, unsaved records.

7.  Issue: `NoMethodError: undefined method 'learned_on' for #<Learning ...>` on `new` learning page.
    *   Context: The `new.html.erb` view tried to access `@learning.learned_on` to set the default value for the date field.
    *   Resolution: I changed the `date_field` value in the view from `@learning.learned_on || Date.today` to just `Date.today`. The `@learning` instance in the `new` action is unsaved and doesn't have the `learned_on` attribute populated until saved; the database default doesn't apply to the in-memory object.
    *   Learning: I learned to be mindful of when database defaults are applied (on save) versus needing to set defaults explicitly in the controller or view for new object instances.

## Session: Apr 14, 2024

1.  Issue: GitHub Actions CI failing on my PR.
    *   Context: PR checks failed with errors related to `rubocop` not being found and `bin/importmap` not existing.
    *   Resolution:
        *   I uncommented the `rubocop-rails-omakase` gem in the `Gemfile` (group `:development, :test`) to include RuboCop in the bundle.
        *   I corrected the importmap audit command in `.github/workflows/ci.yml` from `bin/importmap audit` to the standard Rails command `bin/rails importmap:audit`.
    *   Learning: I learned that CI environments install dependencies based strictly on `Gemfile.lock`. I need to ensure all required gems (especially for linting/testing steps) are included. I also learned to double-check the exact commands used in CI workflows against standard Rails commands or existing binstubs.

2.  Issue: Subsequent CI failures after fixing initial errors.
    *   Context: Rubocop reported style violations (whitespace, empty lines), and `bin/rails importmap:audit` resulted in an "Unrecognized command" error.
    *   Resolution:
        *   Rubocop: I decided to run `rbenv exec bundle exec rubocop -A` locally before committing to auto-correct style violations.
        *   Importmap Audit: I changed the command in `.github/workflows/ci.yml` to `bundle exec rails importmap:audit` to ensure the task runs within the correct bundle context.
    *   Learning: Regularly running the linter (`rubocop -A`) locally prevents style errors from reaching CI. I learned that using `bundle exec` for Rails/Rake tasks in CI can sometimes resolve environment or command recognition issues.

3.  Issue: Persistent CI failure attempting to run `importmap:audit` via `rails`, `rake`, or `rake environment`.
    *   Context: The CI job `scan_js` consistently failed with errors indicating the task `importmap:audit` could not be found or run.
    *   Resolution: I verified locally using `rake -T | grep importmap` that the `importmap:audit` task was not available in my project's current setup (Rails version, `importmap-rails` version). I removed the entire `scan_js` job from `.github/workflows/ci.yml`.
    *   Learning: Before troubleshooting CI command failures extensively, I learned to verify that the command/task actually exists and is available in my project's specific gem/framework versions. I shouldn't assume standard template tasks are always applicable or available.

## Session: Apr 14, 2024 (Continued)

*(Tag Filtering Implementation & Testing)*

1.  Action: I implemented tag filtering feature.
    *   Details: I added a `tag_list` helper to the `Learning` model. I updated `LearningsController#index` to filter by `params[:tag]` and collect unique tags. I updated `index.html.erb` with `turbo_frame_tag`, clickable tag links, and filter controls. I added basic CSS styling for tags.
    *   Learning: I learned that simple string-based tags can be made functional for filtering using basic Rails querying (`LIKE`) and Turbo Frames for efficient UI updates, adhering to the 37signals principle of starting simple.

2.  Issue: Request spec failure: `Failure/Error: expect(response).to render_template(:new) ... assert_template has been extracted to a gem. To continue using it, add `gem 'rails-controller-testing'` to your Gemfile.`
    *   Context: The `render_template` matcher in my RSpec request specs relies on functionality (`assert_template`) that is no longer part of Rails core.
    *   Resolution: I added `gem 'rails-controller-testing'` to the `:test` group in the `Gemfile` and ran `bundle install`.
    *   Learning: I learned to be aware that testing helpers previously included in Rails core might be extracted into separate gems in newer versions. Error messages usually indicate the required gem.

3.  Issue: Request spec failures: `StaticPages GET /... returns http success` failed with `Expected response to be a <2XX: success>, but was a <404: Not Found>`. Occurred for `/home`, `/hire_me`, `/about` specs.
    *   Context: The specs in `spec/requests/static_pages_spec.rb` were using hardcoded string paths (e.g., `get "/static_pages/home"`) that didn't match the actual routes defined in `config/routes.rb`.
    *   Resolution: I updated the specs to use the correct Rails path helpers (`get root_path`, `get hire_me_path`, `get about_path`).
    *   Learning: I learned to always use Rails path helpers (e.g., `root_path`, `learnings_path`) in request/system specs instead of hardcoding URL strings to ensure tests remain accurate even if routes change and to avoid simple 404 errors.

4.  My Observation: RSpec reported pending examples for `spec/models/learning_spec.rb`.
    *   Context: The generated model spec file contains a placeholder pending test.
    *   Resolution: Needs implementation of model tests (validations) as per `TASK.md`.
    *   Learning: Pending specs are reminders from RSpec to write tests for specific files/contexts. They don't indicate errors but highlight missing test coverage.
    *   Next Step: Implement tests for `title` and `body` presence validations, and optionally for the `tag_list` helper method.

## Session: Apr 14, 2024 (Deployment)

1.  Issue: My initial deployment attempt on Render using Static Site service type failed.
    *   Context: The Static Site service type is only for pre-built HTML/CSS/JS files and does not run a backend server process like Rails requires (Puma).
    *   Resolution: I deleted the Static Site service and created a new Web Service on Render.
    *   Learning: Rails applications require a dynamic backend environment. I learned to use Render's "Web Service" type, not "Static Site".

2.  Issue: Build failures related to database configuration (`ActiveRecord::DatabaseConfigurations::DatabaseNotDefined: Database configuration "'default'" not defined`).
    *   Context: The default `config/database.yml` included a complex multi-database production setup that was incompatible with Render's standard `DATABASE_URL` approach.
    *   Resolution: I simplified the `production:` block in `config/database.yml` to inherit defaults and rely solely on the `DATABASE_URL` environment variable provided by Render.
    *   Learning: For standard PaaS deployments (like Render), I learned to configure the `production` database using `url: <%= ENV["DATABASE_URL"] %>` or rely on Rails' automatic merging of the `DATABASE_URL` environment variable. Avoid complex hardcoded setups unless explicitly needed and configured on the host.

3.  Issue: Deployment stuck after I added `puma` to the Build Command.
    *   Context: The `puma` command starts a long-running server process, but the Build Command expects tasks that finish.
    *   Resolution: I removed `puma` from the Build Command and placed it in the dedicated Start Command field in Render's Web Service settings (`bundle exec puma -C config/puma.rb`).
    *   Learning: I learned to distinguish between Build Commands (setup tasks that finish) and Start Commands (long-running server processes) in deployment configurations.

4.  Issue: Runtime errors (`ActiveRecord::ConnectionNotEstablished`) trying to connect via local socket (`/var/run/postgresql/.s.PGSQL.5432`).
    *   Context: Despite `config/database.yml` being configured for `DATABASE_URL`, Rails was not running in the `production` environment, causing it to default to socket connections.
    *   Cause 1: The Start Command initially included `-e ${RACK_ENV:-development}` or similar, overriding the production setting.
    *   Cause 2: The `RAILS_ENV` environment variable was missing in Render.
    *   Cause 3: Puma reported `Environment: deployment` even with `RAILS_ENV=production` set, suggesting `RACK_ENV` might take precedence.
    *   Resolution:
        *   I changed the Start Command to `bundle exec puma -C config/puma.rb`.
        *   I explicitly added both `RAILS_ENV=production` and `RACK_ENV=production` environment variables in Render's UI.
    *   Learning: I learned to ensure the Rails environment is correctly set to `production` on the deployment server via `RAILS_ENV` and potentially `RACK_ENV` environment variables. I need to verify the environment Puma reports in the logs.

5.  Issue: Continued socket connection errors even with `production` environment confirmed.
    *   Context: The `DATABASE_URL` environment variable was missing from my Web Service configuration.
    *   Cause: The Render PostgreSQL database service was not automatically linked to the Web Service when I created it, or the link was broken.
    *   Resolution: I manually located the database connection string from the database service's page in Render and added it as the `DATABASE_URL` environment variable to the Web Service.
    *   Learning: I learned to verify that the `DATABASE_URL` environment variable exists and is correctly populated in the deployment environment. If using linked services (like Render databases), I need to ensure the link is active or manually provide the connection string if necessary.

6.  Issue: Running initial database migrations on Render's free tier without Shell access or Pre-Deploy command support.
    *   Context: Migrations (`rails db:migrate`) must run after deployment to create the schema but cannot be executed via standard methods on the free plan.
    *   Resolution (Workaround): I temporarily added `bundle exec rails db:migrate` to the *end* of the Build Command in Render settings for the first successful deployment.
    *   Learning: On restricted environments, essential post-deploy tasks like migrations might need temporary workarounds, such as including them in the build command. I learned to remember to potentially remove them later for efficiency.

- Model: `spec/models/learning_spec.rb` (Added Apr 14, 2024)

## Session: Apr 15, 2024

1.  Issue: `FactoryBot::DuplicateDefinitionError: Factory already registered: learning` during development server startup (`./bin/dev`).
    *   Context: My development server failed to boot, reporting that the `learning` factory was defined twice.
    *   Cause: The `factory_bot_rails` gem was included in the `group :development, :test do` block in the `Gemfile`. This caused FactoryBot's Railtie to load factory definitions (`spec/factories/learnings.rb`) during development environment initialization, potentially conflicting with other initializers or running twice.
    *   Resolution: I moved `gem "factory_bot_rails"` exclusively to the `group :test do` block in the `Gemfile` and ran `rbenv exec bundle install`.
    *   Learning: I learned that gems intended solely for testing (like `factory_bot_rails`) should typically only be included in the `:test` group in the `Gemfile`. Including them in `:development` can lead to unexpected behavior or errors during server startup as their initializers might run inappropriately or cause conflicts.

2.  Issue: `bin/dev` startup requires `./bin/dev` instead of `rbenv exec bin/dev`.
    *   Context: I clarified in `README.md` that `./bin/dev` is the preferred command after confirming `rbenv exec bin/dev` causes issues (previously logged Apr 8 & Apr 13).
    *   Resolution: I updated `README.md` to reflect `./bin/dev` as the primary command and added a note about specifying the `PORT` environment variable (e.g., `PORT=8000 ./bin/dev`).
    *   Learning: I learned to ensure documentation (`README.md`) accurately reflects the working commands discovered during troubleshooting, including common variations like specifying a port.

## Session: Apr 19, 2025

1.  Issue: Newly added "Edit" link for learnings appeared locally but not on my deployed Render application.
    *   Context: The correct commit was confirmed deployed on Render, logs were clean, and the server restarted successfully. My local development server showed the link correctly. Production database had data.
    *   Resolution: I modified the Build Command in Render settings. I changed the order from `...; bundle exec rake assets:precompile; bundle exec rake assets:clean; ...` to `...; bundle exec rake assets:clean; bundle exec rake assets:precompile; ...`. Redeploying with this change made the link appear.
    *   Learning: The order of asset pipeline tasks in the build command matters. I learned that running `assets:clean` *before* `assets:precompile` ensures that stale or conflicting assets from previous builds are removed before new ones are generated, preventing potential issues where old assets might be served or interfere with the latest code changes in the production environment.

## Session: Apr 19, 2024 (Delete Button UI/UX)

1.  Task: Move "Delete Selected" button to top, next to "Log New Learning", and dynamically disable it if no learnings are selected.

2.  Issue: My initial attempt incorrectly moved the entire learnings list along with the button form, breaking the layout.
    *   Resolution: I reverted the changes and restructured the view (`learnings/index.html.erb`) to move only the submit button into the top `.actions` div, then wrapped the actions, filters, and list within the main `form_with` tag.
    *   Learning: I learned to be careful when moving elements within complex form structures, especially those involving Turbo Frames. I need to ensure only the intended element is relocated.

3.  Issue: Despite seemingly correct Stimulus controller (`selection_controller.js`) setup, HTML attributes (`data-controller`, `data-action`, `data-target`), and CSS, the "Delete Selected" button remained disabled even when I checked items.
    *   Context: I performed extensive troubleshooting:
        *   Verified controller registration via `./bin/rails stimulus:manifest:update` and checking `controllers/index.js`.
        *   Verified `javascript_importmap_tags` was present in `layouts/application.html.erb` (it was initially missing and I added it).
        *   Verified `controllers/application.js` correctly started Stimulus.
        *   Added `console.log` statements to the controller; logs did not appear in the browser console, indicating the controller code was not executing.
        *   Tested moving `data-controller` to the `<body>` tag; still no execution.
        *   Checked for conflicting controllers or browser console errors; none found.
    *   Resolution: Due to my inability to diagnose why the Stimulus controller wasn't executing despite seemingly correct configuration, I reverted the dynamic disabling feature. I deleted the controller file, removed the registration, cleaned the `data-` attributes from the view/layout, and removed `:disabled` CSS styles.
    *   Learning: If JavaScript behavior fails without obvious errors after checking standard setup (controller loading, registration, attributes, initialization, console), I learned to consider potential deeper issues with the asset pipeline, JS bundling, or subtle DOM interactions (e.g., with Turbo Frames) that might prevent event listeners or controller connections. In the interest of time/simplicity for this project, reverting the problematic feature was chosen over deeper investigation.

4.  Issue: "Log New Learning" link (`<a>`) and "Delete Selected" button (`<input type="submit">`) had slightly different heights/widths despite similar CSS.
    *   Resolution: I added explicit `box-sizing: border-box;`, `line-height: 1.5;`, and `vertical-align: middle;` to the shared CSS rule for `.button` and `input[type="submit"]`.
    *   Learning: I learned that link tags and submit inputs can have slightly different default browser rendering (padding inclusion, line height, vertical alignment). Explicitly setting these properties in CSS ensures visual consistency between different element types styled as buttons.

## Session: Apr 19, 2024 (Form UI/UX & Asset Pipeline)

1.  Task: Refine the UI/UX of the "Log New Learning" form (`learnings/_form.html.erb`) to align with 37signals principles (better spacing, guidance, alignment, font consistency).

2.  Issue: CSS changes I added to `application.css` for form styling were not reflected in the browser despite server restarts and hard refreshes.
    *   Troubleshooting Steps:
        *   I verified CSS file content (initially seemed correct).
        *   I checked browser Network tab: `application.css` loaded with `200 OK (from memory cache)`, indicating a stale cache.
        *   I ran `rbenv exec rails assets:clobber` and restarted server/hard refreshed; still no change.
        *   I verified `stylesheet_link_tag` in `application.html.erb`.
        *   I checked `Gemfile` for asset pipeline (confirmed `propshaft`).
        *   I checked for `Procfile.dev` (none present, expected for Propshaft).
        *   I checked for `app/assets/config/manifest.js` (none present, expected for Propshaft).
        *   I re-inspected `application.css` (confirmed styles *were* missing).
        *   I re-applied CSS styles; some changes appeared, but not all.
        *   I re-inspected `_form.html.erb` and found that the required HTML structure changes (classes like `form-container`, `form-group`, placeholders) were missing.
    *   Resolution: I re-applied the necessary HTML changes to `_form.html.erb`. This resolved the issue, indicating the previous HTML edit attempt had failed silently or been reverted.
    *   Learning: When CSS doesn't apply as expected, I learned to double-check both the CSS *and* the HTML structure it targets. Asset pipeline issues can be complex, but sometimes the root cause is simply that the HTML/CSS edits weren't applied correctly in the first place. Also, `assets:clobber` is a key tool for suspected caching issues. Propshaft in development typically doesn't require extra processes or manifest files for basic CSS serving.

3.  Issue: Form content (`.form-container`) was slightly indented compared to index page content.
    *   Cause: The `.form-container` rule had horizontal padding (`padding: 0 1rem;`) while the index page content relied on the body's margin.
    *   Resolution: I removed the horizontal padding from `.form-container` CSS rule.
    *   Learning: I learned to ensure consistent container padding/margins across different page templates for visual alignment.

4.  Issue: Font in the `textarea` (body field) differed from `input` fields.
    *   Cause: Textareas can default to monospace fonts; the CSS rule for inputs/textarea didn't explicitly set `font-family`.
    *   Resolution: I added `font-family: inherit;` to the shared CSS rule for `input` and `textarea`.
    *   Learning: I learned to explicitly set `font-family: inherit;` on form controls to ensure consistency with the base body font.

5.  Discussion: I considered alternatives to the native HTML5 `date_field` due to inconsistent styling/icon placement across browsers.
    *   Alternative Considered: Rails `date_select` helper (three dropdowns).
    *   Decision: I stuck with `date_field` for simplicity and reliance on native browser behavior, accepting the styling limitations. I added `(YYYY-MM-DD)` format hint to the label for clarity.
    *   Learning: Native form elements offer simplicity but limited styling control. I learned to weigh the trade-offs between custom (potentially JS-heavy) solutions and accepting native limitations based on project philosophy.

## Session: Apr 20, 2024

1.  Issue: `rails db:seed` failed with `NameError: undefined local variable or method 'params' for main:Object`.
    *   Context: I ran the generated seed script which populated `Learning` records from `LEARNINGS.md`. The error occurred processing an entry whose body contained the literal text `params[:tag]`. The default heredoc syntax (`<<~BODY`) attempted Ruby interpolation (`#{...}`) on this text.
    *   Resolution: I changed the heredoc definition for the problematic entry in `db/seeds.rb` from `<<~BODY` to `<<~'BODY'` (note the single quotes). This prevents interpolation within that specific string, treating it literally.
    *   Learning: I learned to be cautious when using interpolating heredocs (`<<~DELIMITER`) in seed files or scripts if the source text might contain `#{}`, `${}`, or similar sequences that could be misinterpreted as code interpolation. Use non-interpolating heredocs (`<<~'DELIMITER'`) or escape the relevant characters (`\#{}`) within the string if interpolation is needed elsewhere but not for specific literals.

2.  Issue: Seeded learning body text displayed raw HTML elements (e.g., `<input>`) and did not style backticked content (`code`).
    *   Context: The `format_learning_body` helper used `sanitize: false` to preserve `<strong>` tags, but this also allowed other raw HTML from the source text to render. Backticks were preserved but had no special styling.
    *   Resolution: I modified `format_learning_body` helper:
        1.  First, escape all HTML in the input string using `ERB::Util.html_escape`.
        2.  Then, apply bolding to keywords (`<strong>`) on the escaped string.
        3.  Then, wrap content within backticks (`) with `<code>` tags on the bolded string.
        4.  Finally, call `simple_format` with `sanitize: false` to process line breaks while retaining the intentionally added `<strong>` and `<code>` tags.
        5.  Added basic CSS styling for the `code` tag in `application.css`.
    *   Learning: When displaying potentially unsafe text that also needs specific safe HTML formatting (like bolding keywords or adding code tags), I learned the correct order is typically: Escape everything first, *then* selectively add back the desired safe HTML tags, and finally apply structural formatting like `simple_format` (often needing `sanitize: false` at this stage).

## Session: Apr 21, 2024

1.  Issue: My form page (`/learnings/new`, `/learnings/:id/edit`) appeared narrow after CSS cleanup.
    *   Context: Applying `max-width: 700px;` to the `.form-container` class during CSS refactoring inadvertently restricted the entire form area, not just the fields within it on large screens.
    *   Resolution: I removed the `max-width: 700px;` rule from `.form-container` in `application.css`.
    *   Learning: I learned to be mindful of the scope and impact of CSS rules, especially those affecting container widths or layout (`max-width`, `padding`, `margin`). Testing pages after applying broad styling changes is important to ensure no unintended layout consequences.

2.  Clarification: Purpose of `data-turbo-confirm`.
    *   Context: We discussed the meaning of the "`data-turbo-confirm` issue" noted as a TODO.
    *   Explanation: Clarified that `data-turbo-confirm="Are you sure?"` is a Hotwire/Turbo HTML attribute used to automatically trigger a browser confirmation dialog before executing a link click or form submission, commonly used for destructive actions like deletion. The TODO refers to revisiting the addition of this attribute to the "Delete Selected" button, as a previous attempt was commented out.
    *   Learning: I learned to understand standard Hotwire/Turbo attributes like `data-turbo-confirm` for enhancing user experience with minimal JavaScript.

3.  Clarification: CSS Styling Changes (Buttons, Fonts, Tags).
    *   Context: We discussed changes in button color (green to blue), fonts, and tag shapes (pill to squared) after my CSS cleanup.
    *   Explanation:
        *   Buttons: The change to blue (`#007bff`) resulted from my consolidating multiple previous rules for `.button` (links) and `input[type="submit"]` (which had green/red variations) into a single, consistent style rule for simplicity.
        *   Fonts: Adding `font-family: inherit;` to form inputs/textareas ensures they use the main body font stack for consistency across the form and site, even if it looks different from the *previous* potentially inconsistent state.
        *   Tags: The change from pill-shaped (`border-radius: 10rem;`) to squared (`border-radius: 4px;`) was an intentional part of my CSS cleanup, chosen for a cleaner look (and kept based on user preference).
    *   Learning: CSS consolidation aims for simplicity and consistency but can lead to visual changes. I learned that explicitly setting properties like `font-family: inherit;` prevents reliance on varying browser defaults. Documenting intentional style changes is helpful.

## Session: Apr 22, 2024

create_learning(
  "Routing Error for static files (`/documents/cv.pdf`) in development",
  "2024-04-22",
  <<~'BODY',
    Issue: Linking to PDFs I placed in `public/documents/` resulted in `No route matches [GET] /documents/cv.pdf` in the development environment.
    Cause: By default, the Rails development environment often doesn't serve static files from the `public` directory. This is typically enabled only in production for performance reasons.
    Resolution:
    1. I enabled static file serving in development by setting `config.public_file_server.enabled = true` in `config/environments/development.rb`.
    2. I ensured the PDF files were correctly placed in `til_tracker/public/documents/`.
    3. I restarted the Rails server (`./bin/dev`).
    Learning: To serve static assets (like PDFs, images) directly from the `public` folder in the development environment, I learned I must explicitly set `config.public_file_server.enabled = true` in `config/environments/development.rb` and restart the server. In production, this is usually handled by the webserver (like Nginx or Apache) or enabled by default in `production.rb`.
  BODY
  "rails,configuration,development,environment,static-files,public,routing,error,debugging"
)

create_learning(
  "PDF tab title incorrect (comes from embedded metadata)",
  "2024-04-22",
  <<~'BODY',
    Issue: When I opened linked PDFs (`cv.pdf`, `cover_letter.pdf`), the browser tab showed an incorrect title (e.g., "Minimalist White and Grey Professional Resume").
    Cause: The browser tab title for directly viewed PDFs is taken from the `Title` property embedded in the PDF's metadata, set when the PDF was created.
    Resolution: I edited the PDF metadata using a dedicated PDF editor (Nitro PDF Pro, as Preview was insufficient) to change the `Title` property within each PDF file. I re-copied the modified PDFs to `public/documents/`.
    Learning: The display title for linked assets like PDFs is controlled by the asset's internal metadata, not the HTML page linking to it. I learned editing requires tools capable of modifying PDF properties (Preview might not work; Acrobat, Nitro Pro, or other editors are needed).
  BODY
  "pdf,metadata,browser,frontend,debugging,workflow,assets"
)

create_learning(
  "Decided to use `mail_to` helper for email links",
  "2024-04-22",
  <<~'BODY',
    Decision: I changed the static email address text on the Hire Me page to a clickable `mailto:` link using the Rails `mail_to` helper (`<%= mail_to "email@example.com" %>`).
    Reason: Improves usability by allowing users to click the link to open their default email client. The `mail_to` helper is preferred over a raw HTML `mailto:` link as it can offer minor obfuscation against simple bots and is the conventional Rails way.
    Learning: I learned to use the `mail_to` view helper in Rails to generate clickable email links for better user experience and adherence to Rails conventions.
  BODY
  "rails,view,helper,html,frontend,ui,ux,mailto,email"
)

create_learning(
  "Refined 'Hire Me' page narrative (Honesty vs. Potential)",
  "2024-04-22",
  <<~'BODY',
    Context: I revised the content of the `hire_me.html.erb` page to more accurately reflect my journey and experience level for the 37signals Junior Developer role.
    Strategy: I moved away from implying extensive prior Rails experience. Instead, I explicitly stated that my professional Rails experience is limited but framed the TIL Tracker project itself as strong evidence of my rapid learning, problem-solving under pressure, ability to adopt the 37signals way, and high motivation. I emphasized transferable skills from my previous roles (data analysis, communication).
    Learning: When applying for roles, especially stretch roles, I learned that honesty about specific experience gaps combined with a clear demonstration of my learning ability, relevant transferable skills, and genuine enthusiasm/alignment with the company's values can be a very effective narrative. Framing my projects as direct responses to the application requirements strengthens the message.
  BODY
  "job-application,writing,content-strategy,communication,career,37signals"
)

create_learning(
  "Database Reset Issues & `db:seed:replant` Workaround on Render",
  "2024-04-23", # Assuming today's date
  <<~'BODY',
    Context: My first-person perspective changes in `seeds.rb` weren't reflected on Render, even after deploying with `db:migrate; db:seed` in the Pre-Deploy command. I needed a way to ensure a fresh seed.
    Attempt 1 (`db:reset` in shell): Running `DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:reset` in the Render shell failed with `PG::ObjectInUse` because active web server connections prevented dropping the database.
    Attempt 2 (Terminate connections): Trying `SELECT pg_terminate_backend(...)` from `rails dbconsole` failed with permission errors, as my application user lacked `SUPERUSER` rights.
    Attempt 3 (Scale down): Scaling the web service instances to 0 didn't work either (reason unclear).
    Successful Workaround (`db:seed:replant`): Using `DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:seed:replant` in the Pre-Deploy Command field for *one* deployment successfully reset the data. This command truncates the relevant tables before seeding.
    Learning: `db:reset` is difficult on Render without SUPERUSER privileges or reliably stopping connections. `db:seed:replant` can force a reset in the pre-deploy step but is destructive and must be removed immediately after use. The standard `db:migrate; db:seed` (using `find_or_create_by!`) is the safe, idempotent command for regular deploys, ensuring data in `seeds.rb` is present/updated without deleting other records.
  BODY
  "deployment-ci,database,seeds,render,debugging,workflow,reset,replant"
)

puts "Finished seeding Learnings."