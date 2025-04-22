# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding Learnings from LEARNINGS.md..."

# Helper function to create learnings idempotently
def create_learning(title, date_str, body_text, tags_str)
  learned_on_date = Date.parse(date_str)
  Learning.find_or_create_by!(title: title) do |learning|
    learning.learned_on = learned_on_date
    learning.body = body_text.strip
    learning.tags = tags_str
    puts "Creating: #{title}"
  end
rescue Date::Error
  puts "Skipping due to invalid date: #{title} (Date: #{date_str})"
rescue StandardError => e
  puts "Error creating learning '#{title}': #{e.message}"
end

# --- Session: Apr 8, 2024 ---

create_learning(
  "rbenv: bin/dev: command not found with rbenv exec",
  "2024-04-08",
  <<~BODY,
    Context: Attempting to start the Rails development server using the project's specified command style (`rbenv exec ...`).
    Resolution: Found that running `./bin/dev` directly works correctly. The script's shebang (`#!/usr/bin/env ruby`) combined with the existing `rbenv` shim setup ensures the correct Ruby version is used without needing the `rbenv exec` prefix for this specific script. The prefix was causing an execution issue.
    Learning: `rbenv exec` might not always be necessary or beneficial if the target script and shell environment (shims, PATH) are already correctly configured to find the intended Ruby version. In some cases, it can interfere. Project convention updated to note `./bin/dev` might be preferred.
  BODY
  "environment,workflow,rbenv,bin/dev,rbenv-exec,path,shims,configuration,shell"
)

create_learning(
  "Rails generator failed for model name `Til`",
  "2024-04-08",
  <<~BODY,
    Context: Trying to generate the primary model for the application as `Til`. The generator reported `The name 'Til' is either already used...`.
    Resolution: Switched to using the name `Learning` for the model and `LearningsController` for the associated controller. Generated these components successfully and removed the previous partially generated/conflicting `Til` files and migration. Updated `TASK.md` and `routes.rb` accordingly.
    Learning: Be aware of potential naming collisions with Rails internals or reserved words, even if not strictly listed. Choosing a slightly more descriptive or different name can avoid generator issues.
  BODY
  "rails,workflow,generator,model,controller,naming-convention,configuration"
)

create_learning(
  "Rails generator failed for `StaticPagesController` (name collision)",
  "2024-04-08",
  <<~BODY,
    Context: Attempting to generate `StaticPagesController` as per `TASK.md`. Generator failed due to name collision.
    Resolution: Realized the controller already existed (likely from initial `rails new` or prior steps). Verified the existing controller contained the necessary actions (`home`, `hire_me`, `about`).
    Learning: Confirm whether components exist before running generators, especially when resuming work or working from a task list, to avoid simple errors. Check `rails routes` or file structure.
  BODY
  "rails,workflow,generator,controller,naming-convention,configuration"
)

# --- Session: Apr 9, 2024 ---

create_learning(
  "Initial confusion about the project root directory",
  "2024-04-09",
  <<~BODY,
    Context: The AI initially looked for files in the workspace root (`/Users/danildanilov/Documents/GitHub/ruby-app-37s`) instead of the project directory (`/Users/danildanilov/Documents/GitHub/ruby-app-37s/til_tracker`).
    Resolution: User clarified the correct path. Added a note to `PLANNING.md` specifying `til_tracker` as the project root.
    Learning: Always confirm the project's subdirectory structure within the workspace, especially if not at the top level. Update planning docs accordingly. Check current working directory (`pwd`).
  BODY
  "workflow,environment,configuration,documentation,planning"
)

create_learning(
  "NoMethodError: undefined method `pluralize` in controller",
  "2024-04-09",
  <<~BODY,
    Context: The `destroy_multiple` action in `LearningsController` tried to use the `pluralize` helper directly, resulting in `NoMethodError`.
    Resolution: Changed the call to `view_context.pluralize` to access the view helper context from the controller.
    Learning: View helpers like `pluralize` are part of `ActionView` and must be accessed via `view_context` when called from within a controller action.
  BODY
  "rails,controller,view,helper,actionview,nomethoderror"
)

create_learning(
  "`brew services start postgresql` failed (formula not installed)",
  "2024-04-09",
  <<~BODY,
    Context: Trying to start the database service required by the Rails app using `brew services start postgresql`. Failed with `Formula 'postgresql@14' is not installed`.
    Resolution: Installed PostgreSQL using `brew install postgresql`, then started the specific versioned service with `brew services start postgresql@14`.
    Learning: Ensure required background services (like databases) are installed via the package manager (Homebrew) before attempting to start them. Verify the correct formula name if using versioned formulas (e.g., `postgresql@14` vs `postgresql`).
  BODY
  "database,environment,dependencies,postgresql,homebrew,brew"
)

create_learning(
  "`bundle install` failed (`Could not locate Gemfile`)",
  "2024-04-09",
  <<~BODY,
    Context: Running `bundle install` from the parent directory (`ruby-app-37s`) instead of the project root (`til_tracker`).
    Resolution: Changed directory to `til_tracker` before running `bundle install`.
    Learning: Always run commands like `bundle install` or `rails` from the root directory of the specific Rails project. Check `pwd`.
  BODY
  "environment,workflow,bundler,dependencies,shell"
)

create_learning(
  "`bundle install` failed (Could not find required `bundler` version)",
  "2024-04-09",
  <<~BODY,
    Context: `bundle install` failed with `Could not find 'bundler' (2.6.7) required by ... Gemfile.lock`. The active Ruby version (initially system Ruby 2.6) did not have the specific `bundler` gem version required by the project installed.
    Resolution: Attempted `gem install bundler:2.6.7`.
    Learning: Projects lock specific bundler versions in `Gemfile.lock`. The active Ruby environment (managed by `rbenv`) must have this bundler version installed (`gem install bundler -v <version>`).
  BODY
  "environment,dependencies,bundler,gem,rbenv,gemfile.lock,versioning"
)

create_learning(
  "`gem install bundler` failed (`Gem::FilePermissionError`)",
  "2024-04-09",
  <<~BODY,
    Context: `gem install bundler:2.6.7` failed with `Gem::FilePermissionError` for `/Library/Ruby/Gems/2.6.0`. The shell was using the system Ruby (2.6.x), and installing gems globally requires permissions and is generally discouraged. The project's `.ruby-version` specified 3.2.2.
    Resolution: Identified that `rbenv` was installed but not properly activated in the shell environment (`PATH` configuration issue in `.zshrc`).
    Learning: Use a Ruby version manager (`rbenv`) to handle project-specific Ruby versions and avoid modifying the system Ruby installation. Ensure the version manager is correctly initialized in the shell configuration (`.zshrc`, `.zprofile`, etc.). Avoid using `sudo gem install`.
  BODY
  "environment,dependencies,gem,bundler,rbenv,shell,permissions,configuration"
)

create_learning(
  "`rbenv` installed but not activating correctly",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv` installed but not activating correctly (`ruby -v` showed system Ruby, `which gem` showed system gem). The `rbenv init` command in `.zshrc` was not correctly modifying the `PATH` to prioritize `rbenv` shims, potentially due to conflicts or ordering issues within the `.zshrc` file.
    Resolution (Temporary): Manually prepended the shims directory for the current session: `export PATH="$HOME/.rbenv/shims:$PATH"`.
    Resolution (Workaround): Followed the `PLANNING.md` convention of using `rbenv exec` before `bundle` and `rails` commands (e.g., `rbenv exec bundle install`, `rbenv exec rails db:create`).
    Resolution (Permanent Fix Needed): `.zshrc` still requires investigation to ensure `rbenv init` works correctly on shell startup (check order, potential conflicts).
    Learning: Correct shell integration (`eval "$(rbenv init -)"`) is crucial for `rbenv`. Check `PATH` and `.zshrc` initialization order if versions aren't switching automatically. `rbenv exec` is a reliable workaround if shell integration is problematic.
  BODY
  "environment,shell,rbenv,path,configuration,zshrc,workflow"
)

create_learning(
  "`rbenv exec bin/dev` failed initially (Permissions/Directory)",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv exec bin/dev` failed initially. Command was run from the wrong directory (`ruby-app-37s` instead of `til_tracker`) and `bin/dev` potentially lacked execute permissions.
    Resolution: Added execute permissions (`chmod +x til_tracker/bin/dev`), changed to the `til_tracker` directory, and reran `rbenv exec bin/dev`.
    Learning: Ensure scripts have necessary execute permissions (`+x`) and are executed from the correct working directory relative to the project structure (`pwd`).
  BODY
  "environment,workflow,rbenv,bin/dev,permissions,shell"
)

create_learning(
  "`rails new` failed on `bundle install` (pg gem native extension build)",
  "2024-04-09",
  <<~BODY,
    Context: `rails new` failed during initial `bundle install` with `ERROR: Failed to build gem native extension.` for `pg` gem. The `pg` gem requires the PostgreSQL client library (`libpq`) to build its native C extension.
    Resolution: Installed the client library using `brew install libpq`.
    Learning: Native extensions for gems often depend on external system libraries. Read the error messages carefully, as they usually suggest the required package and installation command (e.g., `brew install libpq`).
  BODY
  "environment,dependencies,database,postgresql,pg_gem,bundler,homebrew,native-extension"
)

create_learning(
  "Subsequent `bundle install` failed (bundler version, rbenv context)",
  "2024-04-09",
  <<~BODY,
    Context: Even after installing `libpq`, `bundle install` failed again with `Could not find 'bundler' (2.6.7) ...`. The shell was still trying to use the system Ruby's environment/bundler version, indicating `rbenv` wasn't fully integrated/activated for the `bundle` command execution.
    Resolution: Attempted `gem install bundler` directly, which failed with `Gem::FilePermissionError` (again trying to use system Ruby gems location).
    Learning: Persistent environment issues suggest deeper problems with shell initialization (`.zshrc`) or PATH order. Verified `rbenv` path was missing/incorrectly configured. Ensure `rbenv` is active before running `bundle`.
  BODY
  "environment,dependencies,bundler,gem,rbenv,shell,path,configuration"
)

create_learning(
  "`rbenv` PATH missing, `gem install bundler` fails (permission error)",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv init` in `.zshrc` likely placed incorrectly, preventing shims from being added to the PATH early enough. `gem install bundler` still fails with permission error.
    Resolution (Workaround): Used `rbenv exec gem install bundler -v 2.6.7` to successfully install bundler within the correct Ruby 3.2.2 context managed by rbenv.
    Learning: `rbenv exec` forces the command to run within the context of the selected `rbenv` version, bypassing potential PATH or shell integration issues. It's a reliable way to ensure the correct Ruby environment is used when shell activation is faulty.
  BODY
  "environment,dependencies,gem,bundler,rbenv,shell,path,configuration,permissions,rbenv-exec"
)

create_learning(
  "`rbenv exec bundle install` failed (`pg` gem build header not found)",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv exec bundle install` failed again on `pg` gem build (`Can't find the 'libpq-fe.h' header`). Although `libpq` was installed via Homebrew, the build process (even when run via `rbenv exec`) didn't know where to find the necessary header files and libraries.
    Resolution: Explicitly configured Bundler to tell the `pg` gem build process where to find the Homebrew `libpq` installation using `rbenv exec bundle config build.pg --with-pg-config=/opt/homebrew/opt/libpq/bin/pg_config`, followed by `rbenv exec bundle install`.
    Learning: For gems with native extensions that depend on external libraries installed in non-standard locations (like Homebrew on Apple Silicon), you may need to provide explicit configuration hints to the build process using `bundle config build.<gem_name> --with-<config-option>=/path/to/dependency`. Check `brew info libpq` for paths.
  BODY
  "environment,dependencies,database,postgresql,pg_gem,bundler,homebrew,native-extension,configuration,rbenv-exec"
)

create_learning(
  "`rbenv exec rails db:create` failed (`ActiveRecord::ConnectionNotEstablished`)",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv exec rails db:create` failed with `ActiveRecord::ConnectionNotEstablished`. The PostgreSQL server was not running or accessible.
    Resolution: Started the PostgreSQL service (e.g., `brew services start postgresql`).
    Learning: Ensure required background services like databases are running before Rails attempts to connect to them (e.g., `rails db:create`, `rails server`). Check service status (`brew services list`).
  BODY
  "database,environment,postgresql,rails,activerecord,connection,brew"
)

# --- Session: Apr 12, 2024 ---

create_learning(
  "UI alignment issues with custom checkboxes and titles",
  "2024-04-12",
  <<~BODY,
    Context: When displaying learning items in the index view, the selection checkbox and title were misaligned, with the title appearing below the checkbox.
    Resolution: Implemented a CSS-only selectable box pattern using hidden checkboxes and custom indicators, along with careful flexbox alignment (`display: flex`, `align-items: center`) and margin adjustments to ensure consistent layout.
    Learning: Pure CSS solutions can often replace JavaScript for simple interactions. Using the `<label>` element wrapping a checkbox creates native toggle behavior. CSS selectors like `:checked + .element` enable styling based on input states. Flexbox is powerful for alignment.
  BODY
  "frontend,ui,ux,css,html,css-alignment,flexbox,css-selector,checkbox,form"
)

create_learning(
  "Default checkboxes looked out of place in minimal UI",
  "2024-04-12",
  <<~BODY,
    Context: The default browser checkboxes were not aligned with the clean, minimal aesthetic desired for the application (37signals style).
    Resolution: Created custom selection indicators using CSS (pseudo-elements `::before`, `::after`), with different styling for unselected, hover, and selected states. Used a circular indicator with a checkmark that appears when selected. Hid the default checkbox (`appearance: none` or similar).
    Learning: Custom form controls can be built using the combination of visually hidden native inputs (for accessibility and functionality) paired with styled elements/pseudo-elements for visual presentation. This maintains native browser behaviors while allowing complete visual customization.
  BODY
  "frontend,ui,ux,css,html,css-form,checkbox,pseudo-element,accessibility,37signals"
)

# --- Session: Apr 13, 2024 ---

create_learning(
  "Project cleanup: Removed unused Rails directories/files",
  "2024-04-13",
  <<~BODY,
    Action: Performed project cleanup to align with 37signals minimal approach.
    Details: Identified and removed standard Rails directories/files not actively used: `app/jobs/`, `app/mailers/`, `app/helpers/`, `app/controllers/concerns/`, `vendor/`, `script/`, `storage/`, corresponding `spec/helpers/` files. Removed configuration files for unused tools/services: `.kamal/`, `.github/` (partially, CI kept), `Dockerfile`, `.dockerignore`, `.rubocop.yml`. Removed default Rails icons from `public/`.
    Learning: Regularly review default Rails structure and remove components not essential to the application's core functionality to maintain simplicity and reduce clutter. Check project requirements.
  BODY
  "workflow,rails,configuration,cleanup,simplicity,37signals"
)

create_learning(
  "Project cleanup: Removed unused gems",
  "2024-04-13",
  <<~BODY,
    Action: Reviewed `Gemfile` and removed unused gems.
    Details: Identified and removed `solid_queue` (no jobs), `solid_cable` (no Action Cable), `jbuilder` (no JSON API), `kamal` (not deployment target), `rubocop-rails-omakase` (no active linting at the time). Ran `bundle install`.
    Learning: Keep `Gemfile` lean by removing dependencies that aren't actively used to speed up builds, reduce potential conflicts, and simplify the project. Run `bundle install` after changes.
  BODY
  "workflow,dependencies,gem,bundler,gemfile,cleanup,simplicity"
)

create_learning(
  "Repeated `bundle install` failure (bundler version mismatch)",
  "2024-04-13",
  <<~BODY,
    Context: After cleanup, `bundle install` failed again (`Could not find 'bundler' (2.6.7)...`). Shell environment was attempting to use system Ruby's bundler, not the one associated with the project's `rbenv` version (3.2.2), and the required version (2.6.7) wasn't installed for the active Ruby.
    Resolution Attempt: `gem install bundler:2.6.7`.
    Learning: `Gemfile.lock` dictates the required Bundler version. Ensure this version is installed *for the correct, active Ruby version* managed by `rbenv` (or similar). Verify `ruby -v` and `which gem`.
  BODY
  "environment,dependencies,bundler,gem,rbenv,gemfile.lock,versioning"
)

create_learning(
  "Repeated `gem install bundler` failure (`Gem::FilePermissionError`)",
  "2024-04-13",
  <<~BODY,
    Context: `gem install bundler:2.6.7` failed again with `Gem::FilePermissionError`. The command was still running in the context of the system Ruby, attempting to write to protected system directories (`/Library/Ruby/Gems/2.6.0`).
    Resolution: Required user intervention to ensure the terminal session correctly activated the `rbenv` Ruby version (3.2.2) *before* running `gem install bundler -v 2.6.7` and subsequent `bundle install`.
    Learning: Persistent permission errors during `gem install` strongly indicate the wrong Ruby environment is active. Verify `rbenv` (or similar) setup and activation (`ruby -v`, `which ruby`, `which gem`). Using `rbenv exec gem install ...` can sometimes bypass activation issues but doesn't fix underlying environment problems if shell init is broken.
  BODY
  "environment,dependencies,gem,bundler,rbenv,shell,permissions,configuration"
)

create_learning(
  "Inconsistent need for `rbenv exec` with `bin/dev`",
  "2024-04-13",
  <<~BODY,
    Context: `rbenv exec bin/dev` failed (`rbenv: bin/dev: command not found`), repeating a similar issue from Apr 8.
    Observation: The `bin/dev` script itself likely works fine when executed directly (`./bin/dev`) if the `PATH` includes the `rbenv` shims correctly.
    Learning: The need for `rbenv exec` seems inconsistent, particularly with binstubs like `bin/dev`. This likely points to subtle issues in the shell's `rbenv init` configuration or `PATH` setup. While `rbenv exec` is a workaround for `rails`, `bundle`, `rake`, it might interfere with correctly shimmed binstubs. Recommending `./bin/dev` as the primary way to start the server, potentially falling back to `rbenv exec` if `./bin/dev` uses the wrong Ruby. Document the preferred method.
  BODY
  "environment,workflow,rbenv,bin/dev,rbenv-exec,path,shims,configuration,shell,documentation"
)

create_learning(
  "Feature: Implemented retroactive learning logging",
  "2024-04-13",
  <<~BODY,
    Feature: Implemented retroactive learning logging.
    Details: Added `learned_on` date field (`type: :date`, `null: false`, `default: 'CURRENT_DATE'`) to `Learning` model/migration. Updated controller `learning_params` to permit `:learned_on`. Updated `index` sorting to use `ORDER BY learned_on DESC, created_at DESC`. Added `date_field` to `_form.html.erb`. Updated `index` view display.
    Learning: Using SQL default `CURRENT_DATE` is effective for database-level defaults upon record creation. However, for new, unsaved records in a form, a default needs to be set in the view (e.g., `<%= form.date_field :learned_on, value: Date.today %>`) or controller (`@learning = Learning.new(learned_on: Date.today)`).
  BODY
  "feature,rails,model,migration,controller,view,form,database,sql,date"
)

create_learning(
  "NoMethodError: undefined method `learned_on` on `new` learning page",
  "2024-04-13",
  <<~BODY,
    Context: The `new.html.erb` view tried to access `@learning.learned_on` to set the default value for the date field (`value: @learning.learned_on || Date.today`), causing `NoMethodError`.
    Resolution: Changed the `date_field` value in the view to just `value: Date.today`. The `@learning` instance created by `LearningsController#new` (`Learning.new`) is unsaved and doesn't have attributes populated from database defaults until saved.
    Learning: Be mindful of when database defaults are applied (on save) versus needing to set defaults explicitly in the controller (`Model.new(attr: default)`) or view (`value: default`) for new object instances presented in forms.
  BODY
  "rails,controller,view,form,model,date,nomethoderror,database,default"
)

# --- Session: Apr 14, 2024 ---

create_learning(
  "GitHub Actions CI failing (Rubocop/Importmap missing)",
  "2024-04-14",
  <<~BODY,
    Context: PR checks failed with errors related to `rubocop` not being found and `bin/importmap` command not existing.
    Resolution:
    *   Uncommented the `rubocop-rails-omakase` gem in the `Gemfile` (group `:development, :test`) to include RuboCop in the bundle for the CI environment.
    *   Corrected the importmap audit command in `.github/workflows/ci.yml` from `bin/importmap audit` to the standard Rails command `bin/rails importmap:audit`.
    Learning: CI environments install dependencies based strictly on `Gemfile.lock`. Ensure all required gems (especially for linting/testing steps) are included in the correct groups. Double-check the exact commands used in CI workflows against standard Rails commands or existing binstubs.
  BODY
  "ci,github-actions,dependencies,gemfile,rubocop,importmap,workflow,configuration"
)

create_learning(
  "Subsequent CI failures (Rubocop style / Importmap command)",
  "2024-04-14",
  <<~BODY,
    Context: After fixing initial errors, CI failed again. Rubocop reported style violations (whitespace, empty lines), and `bin/rails importmap:audit` resulted in an "Unrecognized command" error.
    Resolution:
    *   **Rubocop:** Recommended running `rbenv exec bundle exec rubocop -A` locally before committing to auto-correct style violations. Added this as a step in `PLANNING.md`/`README.md`.
    *   **Importmap Audit:** Changed the command in `.github/workflows/ci.yml` to `bundle exec rails importmap:audit` to ensure the task runs within the correct bundle context.
    Learning: Regularly running the linter (`rubocop -A`) locally prevents style errors from reaching CI. Using `bundle exec` before Rails/Rake tasks in CI can sometimes resolve environment or command recognition issues by ensuring the command runs within the context of the installed gems.
  BODY
  "ci,github-actions,rubocop,importmap,workflow,configuration,linting,bundler"
)

create_learning(
  "Persistent CI failure: `importmap:audit` task not found",
  "2024-04-14",
  <<~BODY,
    Context: The CI job `scan_js` consistently failed with errors indicating the task `importmap:audit` could not be found or run, even using `rails`, `rake`, or `bundle exec`.
    Resolution: Verified locally using `rake -T | grep importmap` that the `importmap:audit` task was not available in the project's current setup (Rails version, `importmap-rails` version). Removed the entire `scan_js` job from `.github/workflows/ci.yml`.
    Learning: Before troubleshooting CI command failures extensively, verify that the command/task actually exists and is available in the project's specific gem/framework versions (`rake -T`, `rails -T`). Don't assume standard template tasks are always applicable or available.
  BODY
  "ci,github-actions,importmap,rails,rake,workflow,configuration,dependencies"
)

create_learning(
  "Feature: Implemented tag filtering",
  "2024-04-14",
  <<~'BODY',
    Action: Implemented tag filtering feature.
    Details: Added `tag_list` helper to `Learning` model (simple `tags.split(',').map(&:strip)`). Updated `LearningsController#index` to filter by `params[:tag]` (`where("tags LIKE ?", "%#{params[:tag]}%")`) and collect unique tags for the view (`Learning.pluck(:tags).flat_map { |t| t.split(',') }.uniq`). Updated `index.html.erb` with `turbo_frame_tag` around the list, clickable tag links (`link_to tag, learnings_path(tag: tag)`), and filter controls. Added basic CSS styling for tags.
    Learning: Simple string-based tags (comma-separated) can be made functional for filtering using basic Rails querying (`LIKE` or `string_to_array` in PG) and Turbo Frames for efficient UI updates without full page reloads, adhering to the 37signals principle of starting simple.
  BODY
  "feature,rails,model,controller,view,tags,filtering,turbo,hotwire,sql,like,css,ui,37signals"
)

create_learning(
  "Request spec failure (`render_template` matcher missing)",
  "2024-04-14",
  <<~BODY,
    Context: Request spec failure: `Failure/Error: expect(response).to render_template(:new) ... assert_template has been extracted to a gem. To continue using it, add `gem 'rails-controller-testing'` to your Gemfile.` The `render_template` matcher in RSpec request specs relies on functionality (`assert_template`) that is no longer part of Rails core.
    Resolution: Added `gem 'rails-controller-testing'` to the `:test` group in the `Gemfile` and ran `bundle install`.
    Learning: Be aware that testing helpers previously included in Rails core might be extracted into separate gems in newer versions. Error messages usually indicate the required gem (`rails-controller-testing` for `render_template`, `assigns`, `assert_template`).
  BODY
  "testing,rails,rspec,request-spec,dependencies,gem,controller-testing,gemfile"
)

create_learning(
  "Request spec failures (`StaticPages` 404s)",
  "2024-04-14",
  <<~BODY,
    Context: Request spec failures: `StaticPages GET /... returns http success` failed with `Expected response to be a <2XX: success>, but was a <404: Not Found>`. Occurred for `/home`, `/hire_me`, `/about` specs in `spec/requests/static_pages_spec.rb`. Specs were using hardcoded string paths (e.g., `get "/static_pages/home"`) that didn't match the actual routes defined in `config/routes.rb`.
    Resolution: Updated the specs to use the correct Rails path helpers (`get root_path`, `get hire_me_path`, `get about_path`) defined by `config/routes.rb`.
    Learning: Always use Rails path helpers (e.g., `root_path`, `learnings_path`, `hire_me_path`) in request/system specs instead of hardcoding URL strings. This ensures tests remain accurate even if routes change and avoids simple 404 errors. Use `rails routes` to check available helpers.
  BODY
  "testing,rails,rspec,request-spec,routes,path-helpers,configuration"
)

create_learning(
  "Observation: Pending model specs for `Learning`",
  "2024-04-14",
  <<~BODY,
    Observation: RSpec reported pending examples for `spec/models/learning_spec.rb`.
    Context: The generated model spec file contains a placeholder pending test (`pending "add some examples to (or delete) #{__FILE__}"`).
    Resolution: Needs implementation of model tests (e.g., for validations) as per `TASK.md`.
    Learning: Pending specs are reminders from RSpec to write tests for specific files/contexts. They don't indicate errors but highlight missing test coverage. Address them by writing tests or removing the spec file if not needed.
    Next Step: Implement tests for `title` and `body` presence validations, and optionally for the `tag_list` helper method.
  BODY
  "testing,rails,rspec,model-spec,workflow,coverage"
)

create_learning(
  "Initial Render deployment failed (Static Site vs Web Service)",
  "2024-04-14",
  <<~BODY,
    Context: Initial deployment attempt on Render using **Static Site** service type failed. The Static Site service type is only for pre-built HTML/CSS/JS files and does not run a backend server process like Rails requires (Puma).
    Resolution: Deleted the Static Site service and created a new **Web Service** on Render.
    Learning: Rails applications require a dynamic backend environment capable of running a server process (like Puma). Use Render's "Web Service" type, not "Static Site", for deploying Rails apps.
  BODY
  "deployment,render,configuration,rails,server,puma"
)

create_learning(
  "Render build failures (`DatabaseNotDefined`)",
  "2024-04-14",
  <<~BODY,
    Context: Build failures related to database configuration (`ActiveRecord::DatabaseConfigurations::DatabaseNotDefined: Database configuration "'default'" not defined`). The default `config/database.yml` included a complex multi-database production setup that was incompatible with Render's standard `DATABASE_URL` environment variable approach.
    Resolution: Simplified the `production:` block in `config/database.yml` to inherit defaults and rely solely on the `DATABASE_URL` environment variable provided by Render (e.g., `production:
  <<: *default
  url: <%= ENV['DATABASE_URL'] %>`). Rails 7+ often handles `DATABASE_URL` automatically if the production block is simple enough or just inherits defaults.
    Learning: For standard PaaS deployments (like Render, Heroku), configure the `production` database section in `config/database.yml` to use the `DATABASE_URL` environment variable provided by the host. Avoid complex hardcoded setups unless explicitly needed and configured on the host. Rely on Rails conventions.
  BODY
  "deployment,render,configuration,database,postgresql,database.yml,environment-variable,activerecord"
)

create_learning(
  "Render deployment stuck (Puma in Build Command)",
  "2024-04-14",
  <<~BODY,
    Context: Deployment stuck after adding `puma` to the **Build Command** in Render settings. The `puma` command starts a long-running server process, but the Build Command expects tasks that finish (like `bundle install`, `assets:precompile`).
    Resolution: Removed `puma` from the Build Command and placed it in the dedicated **Start Command** field in Render's Web Service settings (e.g., `bundle exec puma -C config/puma.rb`).
    Learning: Distinguish between Build Commands (setup tasks that complete, e.g., installing dependencies, compiling assets) and Start Commands (long-running server processes) in deployment platform configurations like Render.
  BODY
  "deployment,render,configuration,server,puma,build-command,start-command"
)

create_learning(
  "Render runtime errors (`ActiveRecord::ConnectionNotEstablished` - Socket)",
  "2024-04-14",
  <<~BODY,
    Context: Runtime errors (`ActiveRecord::ConnectionNotEstablished`) trying to connect via local socket (`/var/run/postgresql/.s.PGSQL.5432`). Despite `config/database.yml` being configured for `DATABASE_URL`, Rails was not running in the `production` environment, causing it to default to socket connections defined elsewhere in `database.yml` (likely development).
    Cause 1: The Start Command initially included `-e ${RACK_ENV:-development}` or similar, overriding the production setting.
    Cause 2: The `RAILS_ENV` environment variable was missing or incorrect in Render.
    Cause 3: Puma reported `Environment: development` or `deployment` even with `RAILS_ENV=production` set, suggesting `RACK_ENV` might take precedence or another override was present.
    Resolution:
    *   Changed Start Command to `bundle exec puma -C config/puma.rb` (removing explicit `-e`).
    *   Explicitly added **both** `RAILS_ENV=production` and `RACK_ENV=production` environment variables in Render's UI.
    Learning: Ensure the Rails environment is correctly set to `production` on the deployment server via `RAILS_ENV` (primary) and potentially `RACK_ENV` environment variables. Verify the environment Puma/Rails reports in the logs. Check Start Command for overrides.
  BODY
  "deployment,render,configuration,database,postgresql,environment-variable,rails_env,rack_env,server,puma,activerecord,connection"
)

create_learning(
  "Render: Continued socket errors (Missing `DATABASE_URL`)",
  "2024-04-14",
  <<~BODY,
    Context: Continued socket connection errors even with `production` environment confirmed. The `DATABASE_URL` environment variable itself was missing from the Web Service configuration.
    Cause: The Render PostgreSQL database service was not automatically linked to the Web Service when created, or the link was broken/not established. Render doesn't always automatically inject the `DATABASE_URL` from a linked DB into the web service environment.
    Resolution: Manually located the database 'Internal Connection String' from the database service's page in Render and added it as the `DATABASE_URL` environment variable to the Web Service settings.
    Learning: Verify that the `DATABASE_URL` environment variable exists and is correctly populated in the deployment environment. If using linked services (like Render databases), ensure the link is active and injecting the variable, or manually provide the connection string if necessary.
  BODY
  "deployment,render,configuration,database,postgresql,environment-variable,database_url,connection"
)

create_learning(
  "Render: Running initial migrations on free tier (Build Command workaround)",
  "2024-04-14",
  <<~BODY,
    Context: Needed to run initial database migrations (`rails db:migrate`) on Render's free tier, which lacks Shell access or explicit Pre-Deploy/Post-Deploy command support. Migrations must run after the code is deployed and dependencies installed but before the server starts taking requests based on the new schema.
    Resolution (Workaround): Temporarily added `bundle exec rails db:migrate` to the *end* of the **Build Command** in Render settings for the first successful deployment (e.g., `bundle install; bundle exec rails assets:precompile; bundle exec rails db:migrate`).
    Learning: On restricted environments (like PaaS free tiers), essential post-deploy tasks like database migrations might need temporary workarounds, such as including them at the end of the build command. Remember to remove the migration step from the build command after the first successful run to avoid unnecessary migrations on subsequent deploys and potentially slow down builds. Consider using release phase tasks if the platform supports them (Render paid tiers do).
  BODY
  "deployment,render,database,migration,rails,workflow,configuration,build-command"
)

# --- Session: Apr 15, 2024 ---

create_learning(
  "`FactoryBot::DuplicateDefinitionError` on dev server startup",
  "2024-04-15",
  <<~BODY,
    Context: The development server (`./bin/dev`) failed to boot, reporting `FactoryBot::DuplicateDefinitionError: Factory already registered: learning`.
    Cause: The `factory_bot_rails` gem was included in the `group :development, :test do` block in the `Gemfile`. This caused FactoryBot's Railtie to load factory definitions (`spec/factories/*.rb`) during development environment initialization (e.g., via Spring or initial boot), potentially conflicting with other initializers or running twice.
    Resolution: Moved `gem "factory_bot_rails"` exclusively to the `group :test do` block in the `Gemfile` and ran `rbenv exec bundle install`.
    Learning: Gems intended solely for testing (like `factory_bot_rails`, `shoulda-matchers`, `capybara`) should typically only be included in the `:test` group in the `Gemfile`. Including them in `:development` can lead to unexpected behavior, errors during server startup, or unnecessary loading as their initializers might run inappropriately or cause conflicts.
  BODY
  "testing,dependencies,factorybot,gemfile,environment,workflow,configuration,error"
)

create_learning(
  "Clarification: Use `./bin/dev` not `rbenv exec bin/dev`",
  "2024-04-15",
  <<~BODY,
    Context: Clarified in `README.md` that `./bin/dev` is the preferred command to start the development server, after confirming `rbenv exec bin/dev` causes issues (previously logged Apr 8 & Apr 13).
    Resolution: Updated `README.md` to reflect `./bin/dev` as the primary command and added a note about specifying the `PORT` environment variable if needed (e.g., `PORT=8000 ./bin/dev`).
    Learning: Ensure documentation (`README.md`, `PLANNING.md`) accurately reflects the working commands discovered during troubleshooting and development, including common variations like specifying a port or necessary environment variables. Keep documentation consistent with learned best practices for the specific project environment.
  BODY
  "workflow,documentation,readme,rbenv,bin/dev,environment,configuration"
)

# --- Session: Apr 19, 2025 --- Note: Year seems incorrect in log, assuming 2024

create_learning(
  "Deployed changes (Edit link) not appearing on Render",
  "2024-04-19", # Assuming 2024 based on context
  <<~BODY,
    Context: A newly added "Edit" link for learnings appeared locally but not on the deployed Render application, despite logs showing the correct commit deployed and server restarted.
    Resolution: Modified the **Build Command** in Render settings. Changed the order of asset tasks from `...; bundle exec rake assets:precompile; bundle exec rake assets:clean; ...` to `...; bundle exec rake assets:clean; bundle exec rake assets:precompile; ...`. Redeploying with `clean` before `precompile` made the link appear.
    Learning: The order of asset pipeline tasks in the build command matters, especially with tools like Sprockets or Propshaft. Running `assets:clean` *before* `assets:precompile` ensures that stale or conflicting assets from previous builds are removed before new ones are generated. This prevents potential issues where old assets (CSS, JS) might be served by the CDN or web server, causing new code changes or UI elements not to appear as expected in the production environment.
  BODY
  "deployment,render,assets,asset-pipeline,propshaft,sprockets,cache,frontend,configuration,build-command"
)

# --- Session: Apr 19, 2024 (Delete Button UI/UX) ---

create_learning(
  "Incorrect element movement broke layout (`form_with`/Turbo)",
  "2024-04-19",
  <<~BODY,
    Task: Move "Delete Selected" button to top, next to "Log New Learning".
    Issue: Initial attempt incorrectly moved the entire learnings list (which was inside the `form_with`) along with the button form, breaking the layout significantly.
    Resolution: Reverted changes and restructured the view (`learnings/index.html.erb`). Moved only the submit button (`<input type="submit">`) into the top `.actions` div. Then, ensured the main `form_with` tag wrapped the entire area containing both the actions/button *and* the list with checkboxes.
    Learning: Be careful when moving elements within complex form structures (`form_with`), especially those interacting with Turbo Frames or Streams. Ensure only the intended element is relocated and that the form still correctly encompasses all necessary inputs (checkboxes, submit button). Incorrect nesting can break form submission or layout.
  BODY
  "frontend,ui,ux,layout,html,css,rails,view,form_with,turbo"
)

create_learning(
  "Stimulus controller not executing (dynamic button disable)",
  "2024-04-19",
  <<~BODY,
    Issue: Despite seemingly correct Stimulus controller (`selection_controller.js`) setup, HTML attributes (`data-controller`, `data-action`, `data-target`), and CSS, the "Delete Selected" button remained disabled even when items were checked.
    Context: Extensive troubleshooting performed: Verified controller registration (`stimulus:manifest:update`, `controllers/index.js`), `javascript_importmap_tags` in layout, `controllers/application.js` initialization. Added `console.log` statements; logs did not appear in the browser console, indicating the controller code was not executing. Tested moving `data-controller` scope. Checked for conflicts/errors.
    Resolution: Due to the inability to diagnose why the Stimulus controller wasn't connecting/executing, the dynamic disabling feature was reverted for simplicity. Controller file deleted, registration removed, `data-` attributes cleaned from view/layout, CSS styles removed.
    Learning: If JavaScript behavior (especially Stimulus) fails without obvious errors after checking standard setup (loading, registration, attributes, initialization, console logs), consider potential deeper issues: asset pipeline problems, JS bundling errors (check network tab/console thoroughly), subtle DOM interactions (e.g., Turbo Frames replacing elements Stimulus was connected to), typos in `data-` attributes or controller identifiers, or timing issues. Sometimes reverting to a simpler solution is pragmatic if debugging proves too complex or time-consuming for the feature's value.
  BODY
  "frontend,javascript,stimulus,hotwire,debugging,asset-pipeline,turbo,dom,error"
)

create_learning(
  "Visual inconsistency between `<a>` link and `<input type='submit'` button",
  "2024-04-19",
  <<~BODY,
    Issue: "Log New Learning" link (`<a>` styled as button) and "Delete Selected" button (`<input type="submit">`) had slightly different heights/widths despite sharing similar CSS class (`.button`).
    Resolution: Added explicit `box-sizing: border-box;`, `line-height: 1.5;`, and `vertical-align: middle;` to the shared CSS rule targeting both `.button` and `input[type="submit"]`.
    Learning: Link tags (`<a>`) and submit inputs (`<input type="submit">`) can have slightly different default browser rendering regarding padding inclusion (`box-sizing`), line height, and vertical alignment. Explicitly setting these properties in CSS ensures visual consistency when styling different HTML element types to look like buttons.
  BODY
  "frontend,ui,ux,css,html,css-alignment,button,form,box-sizing"
)

# --- Session: Apr 19, 2024 (Form UI/UX & Asset Pipeline) ---

create_learning(
  "Task: Refine 'Log New Learning' form UI/UX",
  "2024-04-19",
  <<~BODY,
    Task: Refine the UI/UX of the "Log New Learning" form (`learnings/_form.html.erb`) to align with 37signals principles (better spacing, guidance, alignment, font consistency).
    Details: Focused on using standard Rails helpers, hand-crafted CSS, and HTML attributes (`placeholder`) for clear guidance, consistent spacing/fonts, and alignment with the index page layout. Used `_form.html.erb` partial.
    Learning: Good form UI involves clear labels, helpful placeholders, logical grouping (`.form-group`), consistent spacing/typography, and alignment with surrounding page elements. Use partials for DRY forms.
  BODY
  "frontend,ui,ux,css,html,rails,view,form,form_with,partial,37signals"
)

create_learning(
  "CSS changes not reflected (Asset Pipeline/Cache/HTML issue)",
  "2024-04-19",
  <<~BODY,
    Issue: CSS changes added to `application.css` for form styling were not reflected in the browser despite server restarts and hard refreshes.
    Troubleshooting Steps: Verified CSS file content. Checked browser Network tab (saw `200 OK (from memory cache)`, indicating stale cache). Ran `rbenv exec rails assets:clobber` and restarted/refreshed; still no change. Verified `stylesheet_link_tag` in layout. Verified asset pipeline gem (`propshaft`). Checked for potential `Procfile.dev`/`manifest.js` issues (none found/needed for Propshaft dev). Re-inspected CSS/HTML.
    Resolution: Found that the required HTML structure changes (adding classes like `form-container`, `form-group`, placeholders) in `_form.html.erb` were missing/had been reverted. Re-applying the necessary HTML changes resolved the issue.
    Learning: When CSS doesn't apply as expected, double-check *both* the CSS *and* the HTML structure it targets. Asset pipeline issues (caching) can occur, but often the root cause is simpler: the HTML/CSS edits weren't applied correctly or completely in the first place. `rails assets:clobber` is a key tool for suspected CSS/JS caching issues in development. Propshaft in development typically serves assets directly without complex manifests.
  BODY
  "frontend,css,debugging,asset-pipeline,propshaft,cache,html,workflow,assets,clobber"
)

create_learning(
  "Form content indented compared to index page",
  "2024-04-19",
  <<~BODY,
    Issue: Form content (`.form-container`) was slightly indented horizontally compared to the index page content.
    Cause: The `.form-container` CSS rule had horizontal padding (`padding: 0 1rem;`) while the index page content relied on the body's margin or a container without that specific padding.
    Resolution: Removed the horizontal padding (`padding: 0 1rem;`) from the `.form-container` CSS rule to align it with the index page's container.
    Learning: Ensure consistent container padding/margins across different page templates or layouts for visual alignment and a cohesive look. Inspect element styles using browser dev tools.
  BODY
  "frontend,ui,ux,css,layout,css-alignment,padding,margin"
)

create_learning(
  "Textarea font different from input fields",
  "2024-04-19",
  <<~BODY,
    Issue: Font in the `textarea` (body field) differed from `input` fields (e.g., title).
    Cause: Textareas often default to a monospace font in browsers, while other inputs might inherit the body font. The shared CSS rule for inputs/textarea didn't explicitly set `font-family`.
    Resolution: Added `font-family: inherit;` to the shared CSS rule for `input, textarea`.
    Learning: Explicitly set `font-family: inherit;` on form controls (`input`, `textarea`, `select`, `button`) to ensure they consistently use the base font defined higher up in the CSS cascade (e.g., on `body`), avoiding default browser discrepancies.
  BODY
  "frontend,ui,ux,css,html,form,font,textarea,input"
)

create_learning(
  "Discussion: Native `date_field` vs alternatives",
  "2024-04-19",
  <<~BODY,
    Discussion: Considered alternatives to the native HTML5 `date_field` due to inconsistent styling/icon placement across browsers (Chrome vs Firefox vs Safari).
    Alternative Considered: Rails `date_select` helper (outputs three dropdowns: Year, Month, Day). Custom JS date pickers were ruled out by 37signals philosophy.
    Decision: Stuck with `date_field` for simplicity and reliance on native browser behavior, accepting the minor cross-browser styling limitations. Added `(YYYY-MM-DD)` format hint to the label for clarity, as placeholder text isn't supported consistently for date inputs.
    Learning: Native form elements offer simplicity, accessibility, and avoid JS dependencies but have limited styling control. Weigh the trade-offs between custom solutions (more control, more complexity/JS) and accepting native limitations based on project philosophy (e.g., 37signals favors simplicity and defaults). Providing clear labels and format hints is important.
  BODY
  "frontend,ui,ux,html,css,form,date,date_field,date_select,accessibility,browser-compatibility,37signals,decision"
)

# --- Session: Apr 20, 2024 ---

create_learning(
  "`rails db:seed` failed (NameError due to heredoc interpolation)",
  "2024-04-20",
  <<~'BODY', # Using non-interpolating heredoc here too, just in case.
    Context: Running the generated seed script which populated `Learning` records from `LEARNINGS.md`. The error occurred processing an entry whose body contained the literal text `params[:tag]`. The default heredoc syntax (`<<~BODY`) attempted Ruby interpolation (`#{...}`) on this text, causing `NameError: undefined local variable or method 'params' for main:Object`.
    Resolution: Changed the heredoc definition for the problematic entry in `db/seeds.rb` from `<<~BODY` to `<<~'BODY'` (note the single quotes). This prevents interpolation within that specific string, treating it literally.
    Learning: Be cautious when using interpolating heredocs (`<<~DELIMITER`) in seed files or scripts if the source text might contain `#{}`, `${}`, or similar sequences that could be misinterpreted as code interpolation. Use non-interpolating heredocs (`<<~'DELIMITER'`) or escape the relevant characters (`\#{}`) within the string if interpolation is needed elsewhere but not for specific literals.
  BODY
  "seeds,database,ruby,heredoc,interpolation,error,debugging,workflow"
)

create_learning(
  "Seeded text displayed raw HTML & unstyled backticks",
  "2024-04-20",
  <<~'BODY',
    Context: The `format_learning_body` helper used `sanitize: false` to preserve `<strong>` tags, but this also allowed other raw HTML from the source text (like `<input>`) to render. Backticks (`) were preserved but had no special styling.
    Resolution: Modified `format_learning_body` helper:
    1. Escape all HTML first (`ERB::Util.html_escape`).
    2. Bold keywords (`<strong>`) on escaped string.
    3. Wrap backticked content (`) with `<code>` tags on bolded string.
    4. Apply `simple_format(..., sanitize: false)` last.
    5. Added CSS for `code` tag.
    Learning: When displaying potentially unsafe text that also needs specific safe HTML formatting, the order matters: Escape first, then selectively add safe tags, then apply structural formatting (like `simple_format` with `sanitize: false`).
  BODY
  "seeds,formatting,view,helper,html,css,escaping,sanitization,code,bold,frontend,debugging"
)

# --- Session: Apr 21, 2024 ---

create_learning(
  "CSS Layout Fix: Form container width",
  "2024-04-21",
  <<~'BODY',
    Issue: Form pages (`/learnings/new`, edit) appeared narrow after CSS cleanup.
    Context: Applying `max-width: 700px;` to the `.form-container` class during CSS refactoring restricted the entire form area.
    Resolution: Removed the `max-width: 700px;` rule from `.form-container` in `application.css`.
    Learning: Be mindful of the layout impact of CSS rules like `max-width` on containers. Test responsiveness and appearance after changes.
  BODY
  "css,layout,frontend,ui,ux,debugging,css-cleanup"
)

create_learning(
  "Clarification: Turbo's data-turbo-confirm attribute",
  "2024-04-21",
  <<~'BODY',
    Context: Discussion about the purpose of `data-turbo-confirm` attribute.
    Explanation: It's a Hotwire/Turbo HTML attribute (`data-turbo-confirm="Are you sure?"`) that automatically triggers a browser confirmation dialog before executing a link click or form submission.
    Use Case: Commonly used for destructive actions (like deletion) to prevent accidental clicks.
    Learning: Utilize standard Hotwire/Turbo attributes for common UX patterns like confirmation dialogs with minimal effort.
  BODY
  "hotwire,turbo,javascript,frontend,ui,ux,html,attribute"
)

create_learning(
  "Clarification: CSS Styling Consolidation Effects",
  "2024-04-21",
  <<~'BODY',
    Context: Explaining visual changes after CSS cleanup (buttons, fonts, tags).
    Buttons: Change to blue (`#007bff`) resulted from consolidating multiple previous rules for `.button` and `input[type="submit"]` into one consistent style for simplicity.
    Fonts: Adding `font-family: inherit;` to form inputs/textareas ensures they use the main body font stack, improving consistency.
    Tags: Change from pill-shaped (`border-radius: 10rem;`) to squared (`border-radius: 4px;`) was part of the cleanup for a cleaner look.
    Learning: CSS consolidation aims for simplicity but can alter appearance. Explicit styles (`font-family: inherit;`) prevent varying browser defaults. Intentional style changes should be noted.
  BODY
  "css,frontend,ui,ux,refactoring,button,font,tags,consistency,css-cleanup"
)

# --- Session: Apr 22, 2024 ---

create_learning(
  "Routing Error for static files (`/documents/cv.pdf`) in development",
  "2024-04-22",
  <<~'BODY',
    Issue: Linking to PDFs placed in `public/documents/` resulted in `No route matches [GET] /documents/cv.pdf` in the development environment.
    Cause: By default, Rails development environment often doesn't serve static files from the `public` directory. This is typically enabled only in production for performance reasons.
    Resolution:
    1. Enabled static file serving in development by setting `config.public_file_server.enabled = true` in `config/environments/development.rb`.
    2. Ensured the PDF files were correctly placed in `til_tracker/public/documents/`.
    3. Restarted the Rails server (`./bin/dev`).
    Learning: To serve static assets (like PDFs, images) directly from the `public` folder in the development environment, you must explicitly set `config.public_file_server.enabled = true` in `config/environments/development.rb` and restart the server. In production, this is usually handled by the webserver (like Nginx or Apache) or enabled by default in `production.rb`.
  BODY
  "rails,configuration,development,environment,static-files,public,routing,error,debugging"
)

create_learning(
  "PDF tab title incorrect (comes from embedded metadata)",
  "2024-04-22",
  <<~'BODY',
    Issue: When opening linked PDFs (`cv.pdf`, `cover_letter.pdf`), the browser tab showed an incorrect title (e.g., "Minimalist White and Grey Professional Resume").
    Cause: The browser tab title for directly viewed PDFs is taken from the `Title` property embedded in the PDF's metadata, set when the PDF was created.
    Resolution: Edited the PDF metadata using a dedicated PDF editor (Nitro PDF Pro, as Preview was insufficient) to change the `Title` property within each PDF file. Re-copied the modified PDFs to `public/documents/`.
    Learning: The display title for linked assets like PDFs is controlled by the asset's internal metadata, not the HTML page linking to it. Editing requires tools capable of modifying PDF properties (Preview might not work; Acrobat, Nitro Pro, or other editors are needed).
  BODY
  "pdf,metadata,browser,frontend,debugging,workflow,assets"
)

create_learning(
  "Using `mail_to` helper for email links",
  "2024-04-22",
  <<~'BODY',
    Decision: Changed the static email address text on the Hire Me page to a clickable `mailto:` link using the Rails `mail_to` helper (`<%= mail_to "email@example.com" %>`).
    Reason: Improves usability by allowing users to click the link to open their default email client. The `mail_to` helper is preferred over a raw HTML `mailto:` link as it can offer minor obfuscation against simple bots and is the conventional Rails way.
    Learning: Use the `mail_to` view helper in Rails to generate clickable email links for better user experience and adherence to Rails conventions.
  BODY
  "rails,view,helper,html,frontend,ui,ux,mailto,email"
)

create_learning(
  "Refining 'Hire Me' page narrative (Honesty vs. Potential)",
  "2024-04-22",
  <<~'BODY',
    Context: Revised the content of the `hire_me.html.erb` page to more accurately reflect the applicant's journey and experience level for the 37signals Junior Developer role.
    Strategy: Moved away from implying extensive prior Rails experience. Instead, explicitly stated that professional Rails experience is limited but framed the TIL Tracker project itself as strong evidence of rapid learning, problem-solving under pressure, ability to adopt the 37signals way, and high motivation. Emphasized transferable skills from previous roles (data analysis, communication).
    Learning: When applying for roles, especially stretch roles, honesty about specific experience gaps combined with clear demonstration of learning ability, relevant transferable skills, and genuine enthusiasm/alignment with the company's values can be a very effective narrative. Framing projects as direct responses to the application requirements strengthens the message.
  BODY
  "job-application,writing,content-strategy,communication,career,37signals"
)

puts "Finished seeding Learnings."
puts "Created/verified #{Learning.count} learning entries."
