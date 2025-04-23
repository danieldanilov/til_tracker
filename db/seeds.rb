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
    Context: I was attempting to start the Rails development server using the project's specified command style (`rbenv exec ...`).
    Resolution: I found that running `./bin/dev` directly works correctly. The script's shebang (`#!/usr/bin/env ruby`) combined with my existing `rbenv` shim setup ensures the correct Ruby version is used without needing the `rbenv exec` prefix for this specific script. The prefix was causing an execution issue.
    Learning: I learned that `rbenv exec` might not always be necessary or beneficial if the target script and my shell environment (shims, PATH) are already correctly configured to find the intended Ruby version. In some cases, it can interfere. I updated the project convention to note `./bin/dev` might be preferred.
  BODY
  "environment-setup,workflow"
)

create_learning(
  "Rails generator failed for model name `Til`",
  "2024-04-08",
  <<~BODY,
    Context: I was trying to generate the primary model for the application as `Til`. The generator reported `The name 'Til' is either already used...`.
    Resolution: I switched to using the name `Learning` for the model and `LearningsController` for the associated controller. I generated these components successfully and removed the previous partially generated/conflicting `Til` files and migration. I updated `TASK.md` and `routes.rb` accordingly.
    Learning: I learned to be aware of potential naming collisions with Rails internals or reserved words, even if not strictly listed. Choosing a slightly more descriptive or different name can avoid generator issues.
  BODY
  "rails-core,workflow,naming-convention"
)

create_learning(
  "Rails generator failed for `StaticPagesController` (name collision)",
  "2024-04-08",
  <<~BODY,
    Context: I was attempting to generate `StaticPagesController` as per `TASK.md`. The generator failed due to a name collision.
    Resolution: I realized the controller already existed (likely from initial `rails new` or prior steps). I verified the existing controller contained the necessary actions (`home`, `hire_me`, `about`).
    Learning: I learned to confirm whether components exist before running generators, especially when resuming work or working from a task list, to avoid simple errors. I should check `rails routes` or the file structure first.
  BODY
  "rails-core,workflow,naming-convention"
)

# --- Session: Apr 9, 2024 ---

create_learning(
  "Initial confusion about the project root directory",
  "2024-04-09",
  <<~BODY,
    Context: Cursor initially looked for files in the workspace root (`/Users/danildanilov/Documents/GitHub/ruby-app-37s`) instead of my project directory (`/Users/danildanilov/Documents/GitHub/ruby-app-37s/til_tracker`).
    Resolution: I clarified the correct path. I added a note to `PLANNING.md` specifying `til_tracker` as the project root.
    Learning: I learned to always confirm the project's subdirectory structure within the workspace, especially if not at the top level, and update planning docs accordingly. Checking the current working directory (`pwd`) is helpful.
  BODY
  "workflow,environment-setup,project-management,documentation"
)

create_learning(
  "NoMethodError: undefined method `pluralize` in controller",
  "2024-04-09",
  <<~BODY,
    Context: The `destroy_multiple` action in `LearningsController` tried to use the `pluralize` helper directly, resulting in `NoMethodError`.
    Resolution: I changed the call to `view_context.pluralize` to access the view helper context from the controller.
    Learning: I learned that view helpers like `pluralize` are part of `ActionView` and must be accessed via `view_context` when called from within a controller action.
  BODY
  "rails-core,error-handling"
)

create_learning(
  "`brew services start postgresql` failed (formula not installed)",
  "2024-04-09",
  <<~BODY,
    Context: I tried to start the database service required by the Rails app using `brew services start postgresql`. It failed with `Formula 'postgresql@14' is not installed`.
    Resolution: I installed PostgreSQL using `brew install postgresql`, then started the specific versioned service with `brew services start postgresql@14`.
    Learning: I learned to ensure required background services (like databases) are installed via the package manager (Homebrew) before attempting to start them. I also need to verify the correct formula name if using versioned formulas (e.g., `postgresql@14` vs `postgresql`).
  BODY
  "database,environment-setup"
)

create_learning(
  "`bundle install` failed (`Could not locate Gemfile`)",
  "2024-04-09",
  <<~BODY,
    Context: I ran `bundle install` from the parent directory (`ruby-app-37s`) instead of the project root (`til_tracker`).
    Resolution: I changed directory to `til_tracker` before running `bundle install`.
    Learning: I learned to always run commands like `bundle install` or `rails` from the root directory of the specific Rails project. Checking `pwd` helps.
  BODY
  "environment-setup,workflow"
)

create_learning(
  "`bundle install` failed (Could not find required `bundler` version)",
  "2024-04-09",
  <<~BODY,
    Context: `bundle install` failed with `Could not find 'bundler' (2.6.7) required by ... Gemfile.lock`. My active Ruby version (initially system Ruby 2.6) did not have the specific `bundler` gem version required by the project installed.
    My Attempt: `gem install bundler:2.6.7`.
    Learning: Projects lock specific bundler versions in `Gemfile.lock`. My active Ruby environment (managed by `rbenv`) must have this bundler version installed (`gem install bundler -v <version>`).
  BODY
  "environment-setup"
)

create_learning(
  "`gem install bundler` failed (`Gem::FilePermissionError`)",
  "2024-04-09",
  <<~BODY,
    Context: `gem install bundler:2.6.7` failed with `Gem::FilePermissionError` for `/Library/Ruby/Gems/2.6.0`. My shell was using the system Ruby (2.6.x), and installing gems globally requires permissions and is generally discouraged. My project's `.ruby-version` specified 3.2.2.
    Resolution: I identified that `rbenv` was installed but not properly activated in my shell environment (`PATH` configuration issue in `.zshrc`).
    Learning: I learned to use a Ruby version manager (`rbenv`) to handle project-specific Ruby versions and avoid modifying the system Ruby installation. I need to ensure the version manager is correctly initialized in my shell configuration (`.zshrc`, `.zprofile`, etc.) and avoid using `sudo gem install`.
  BODY
  "environment-setup,error-handling"
)

create_learning(
  "`rbenv` installed but not activating correctly",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv` was installed but not activating correctly (`ruby -v` showed system Ruby, `which gem` showed system gem). The `rbenv init` command in my `.zshrc` was not correctly modifying the `PATH` to prioritize `rbenv` shims, potentially due to conflicts or ordering issues within the `.zshrc` file.
    Resolution (Temporary): I manually prepended the shims directory for the current session: `export PATH="$HOME/.rbenv/shims:$PATH"`.
    Resolution (Workaround): I followed the `PLANNING.md` convention of using `rbenv exec` before `bundle` and `rails` commands (e.g., `rbenv exec bundle install`, `rbenv exec rails db:create`).
    Resolution (Permanent Fix Needed): My `.zshrc` still requires investigation to ensure `rbenv init` works correctly on shell startup (check order, potential conflicts).
    Learning: Correct shell integration (`eval "$(rbenv init -)"`) is crucial for `rbenv`. I learned to check `PATH` and `.zshrc` initialization order if versions aren't switching automatically. `rbenv exec` is a reliable workaround if shell integration is problematic.
  BODY
  "environment-setup,workflow"
)

create_learning(
  "`rbenv exec bin/dev` failed initially (Permissions/Directory)",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv exec bin/dev` failed initially. I ran the command from the wrong directory (`ruby-app-37s` instead of `til_tracker`) and `bin/dev` potentially lacked execute permissions.
    Resolution: I added execute permissions (`chmod +x til_tracker/bin/dev`), changed to the `til_tracker` directory, and reran `rbenv exec bin/dev`.
    Learning: I learned to ensure scripts have necessary execute permissions (`+x`) and are executed from the correct working directory relative to the project structure (`pwd`).
  BODY
  "environment-setup,workflow"
)

create_learning(
  "`rails new` failed on `bundle install` (pg gem native extension build)",
  "2024-04-09",
  <<~BODY,
    Context: `rails new` failed during initial `bundle install` with `ERROR: Failed to build gem native extension.` for the `pg` gem. The `pg` gem requires the PostgreSQL client library (`libpq`) to build its native C extension.
    Resolution: I installed the client library using `brew install libpq`.
    Learning: Native extensions for gems often depend on external system libraries. I learned to read the error messages carefully, as they usually suggest the required package and installation command (e.g., `brew install libpq`).
  BODY
  "environment-setup,database"
)

create_learning(
  "Subsequent `bundle install` failed (bundler version, rbenv context)",
  "2024-04-09",
  <<~BODY,
    Context: Even after installing `libpq`, `bundle install` failed again with `Could not find 'bundler' (2.6.7) ...`. My shell was still trying to use the system Ruby's environment/bundler version, indicating `rbenv` wasn't fully integrated/activated for the `bundle` command execution.
    My Attempt: `gem install bundler` directly, which failed with `Gem::FilePermissionError` (again trying to use system Ruby gems location).
    Learning: Persistent environment issues suggest deeper problems with my shell initialization (`.zshrc`) or PATH order. I verified my `rbenv` path was missing/incorrectly configured and learned to ensure `rbenv` is active before running `bundle`.
  BODY
  "environment-setup,error-handling"
)

create_learning(
  "`rbenv` PATH missing, `gem install bundler` fails (permission error)",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv init` in my `.zshrc` was likely placed incorrectly, preventing shims from being added to the PATH early enough. `gem install bundler` still failed with a permission error.
    Resolution (Workaround): I used `rbenv exec gem install bundler -v 2.6.7` to successfully install bundler within the correct Ruby 3.2.2 context managed by rbenv.
    Learning: `rbenv exec` forces the command to run within the context of the selected `rbenv` version, bypassing potential PATH or shell integration issues. It's a reliable way to ensure the correct Ruby environment is used when shell activation is faulty.
  BODY
  "environment-setup,error-handling"
)

create_learning(
  "`rbenv exec bundle install` failed (`pg` gem build header not found)",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv exec bundle install` failed again on `pg` gem build (`Can't find the 'libpq-fe.h' header`). Although I had installed `libpq` via Homebrew, the build process (even when run via `rbenv exec`) didn't know where to find the necessary header files and libraries.
    Resolution: I explicitly configured Bundler to tell the `pg` gem build process where to find the Homebrew `libpq` installation using `rbenv exec bundle config build.pg --with-pg-config=/opt/homebrew/opt/libpq/bin/pg_config`, followed by `rbenv exec bundle install`.
    Learning: For gems with native extensions that depend on external libraries installed in non-standard locations (like Homebrew on Apple Silicon), I learned I may need to provide explicit configuration hints to the build process using `bundle config build.<gem_name> --with-<config-option>=/path/to/dependency`. Checking `brew info libpq` for paths is useful.
  BODY
  "environment-setup,database"
)

create_learning(
  "`rbenv exec rails db:create` failed (`ActiveRecord::ConnectionNotEstablished`)",
  "2024-04-09",
  <<~BODY,
    Context: `rbenv exec rails db:create` failed with `ActiveRecord::ConnectionNotEstablished`. The PostgreSQL server was not running or accessible.
    Resolution: I started the PostgreSQL service (e.g., `brew services start postgresql`).
    Learning: I learned to ensure required background services like databases are running before Rails attempts to connect to them (e.g., `rails db:create`, `rails server`). Checking service status (`brew services list`) is important.
  BODY
  "database,environment-setup,rails-core"
)

# --- Session: Apr 12, 2024 ---

create_learning(
  "UI alignment issues with custom checkboxes and titles",
  "2024-04-12",
  <<~BODY,
    Context: When displaying learning items in the index view, the selection checkbox and title were misaligned, with the title appearing below the checkbox.
    Resolution: I implemented a CSS-only selectable box pattern using hidden checkboxes and custom indicators, along with careful flexbox alignment (`display: flex`, `align-items: center`) and margin adjustments to ensure consistent layout.
    Learning: Pure CSS solutions can often replace JavaScript for simple interactions. I learned that using the `<label>` element wrapping a checkbox creates native toggle behavior. CSS selectors like `:checked + .element` enable styling based on input states. Flexbox is powerful for alignment.
  BODY
  "frontend"
)

create_learning(
  "Default checkboxes looked out of place in minimal UI",
  "2024-04-12",
  <<~BODY,
    Context: The default browser checkboxes were not aligned with the clean, minimal aesthetic I desired for the application (37signals style).
    Resolution: I created custom selection indicators using CSS (pseudo-elements `::before`, `::after`), with different styling for unselected, hover, and selected states. I used a circular indicator with a checkmark that appears when selected and hid the default checkbox (`appearance: none` or similar).
    Learning: I learned that custom form controls can be built using the combination of visually hidden native inputs (for accessibility and functionality) paired with styled elements/pseudo-elements for visual presentation. This maintains native browser behaviors while allowing complete visual customization.
  BODY
  "frontend,project-management"
)

# --- Session: Apr 13, 2024 ---

create_learning(
  "Project cleanup: Removed unused Rails directories/files",
  "2024-04-13",
  <<~BODY,
    What I Did: Performed project cleanup to align with the 37signals minimal approach.
    Details: I identified and removed standard Rails directories/files not actively used: `app/jobs/`, `app/mailers/`, `app/helpers/`, `app/controllers/concerns/`, `vendor/`, `script/`, `storage/`, corresponding `spec/helpers/` files. I removed configuration files for unused tools/services: `.kamal/`, `.github/` (partially, CI kept), `Dockerfile`, `.dockerignore`, `.rubocop.yml`. I removed default Rails icons from `public/`.
    Learning: I learned to regularly review the default Rails structure and remove components not essential to the application's core functionality to maintain simplicity and reduce clutter, checking project requirements.
  BODY
  "workflow,rails-core,project-management"
)

create_learning(
  "Project cleanup: Removed unused gems",
  "2024-04-13",
  <<~BODY,
    What I Did: Reviewed `Gemfile` and removed unused gems.
    Details: I identified and removed `solid_queue` (no jobs), `solid_cable` (no Action Cable), `jbuilder` (no JSON API), `kamal` (not deployment target), `rubocop-rails-omakase` (no active linting at the time). Ran `bundle install`.
    Learning: I learned to keep the `Gemfile` lean by removing dependencies that aren't actively used to speed up builds, reduce potential conflicts, and simplify the project. Running `bundle install` after changes is important.
  BODY
  "workflow,environment-setup"
)

create_learning(
  "Repeated `bundle install` failure (bundler version mismatch)",
  "2024-04-13",
  <<~BODY,
    Context: After cleanup, `bundle install` failed again (`Could not find 'bundler' (2.6.7)...`). My shell environment was attempting to use system Ruby's bundler, not the one associated with my project's `rbenv` version (3.2.2), and the required version (2.6.7) wasn't installed for the active Ruby.
    My Attempt: `gem install bundler:2.6.7`.
    Learning: `Gemfile.lock` dictates the required Bundler version. I learned to ensure this version is installed *for the correct, active Ruby version* managed by `rbenv` (or similar). Verifying `ruby -v` and `which gem` is key.
  BODY
  "environment-setup"
)

create_learning(
  "Repeated `gem install bundler` failure (`Gem::FilePermissionError`)",
  "2024-04-13",
  <<~BODY,
    Context: `gem install bundler:2.6.7` failed again with `Gem::FilePermissionError`. The command was still running in the context of the system Ruby, attempting to write to protected system directories (`/Library/Ruby/Gems/2.6.0`).
    Resolution: I had to ensure my terminal session correctly activated the `rbenv` Ruby version (3.2.2) *before* running `gem install bundler -v 2.6.7` and subsequent `bundle install`.
    Learning: Persistent permission errors during `gem install` strongly indicate the wrong Ruby environment is active. I learned to verify my `rbenv` (or similar) setup and activation (`ruby -v`, `which ruby`, `which gem`). Using `rbenv exec gem install ...` can sometimes bypass activation issues but doesn't fix underlying environment problems if my shell init is broken.
  BODY
  "environment-setup,workflow,error-handling"
)

create_learning(
  "Inconsistent need for `rbenv exec` with `bin/dev`",
  "2024-04-13",
  <<~BODY,
    Context: `rbenv exec bin/dev` failed (`rbenv: bin/dev: command not found`), repeating a similar issue from Apr 8.
    My Observation: The `bin/dev` script itself likely works fine when I execute it directly (`./bin/dev`) if my `PATH` includes the `rbenv` shims correctly.
    Learning: The need for `rbenv exec` seems inconsistent, particularly with binstubs like `bin/dev`. This likely points to subtle issues in my shell's `rbenv init` configuration or `PATH` setup. While `rbenv exec` is a workaround for `rails`, `bundle`, `rake`, it might interfere with correctly shimmed binstubs. I decided to recommend `./bin/dev` as the primary way to start the server, potentially falling back to `rbenv exec` if `./bin/dev` uses the wrong Ruby, and documented the preferred method.
  BODY
  "environment-setup,workflow,documentation"
)

create_learning(
  "Feature: Implemented retroactive learning logging",
  "2024-04-13",
  <<~BODY,
    Feature: I implemented retroactive learning logging.
    Details: I added `learned_on` date field (`type: :date`, `null: false`, `default: 'CURRENT_DATE'`) to the `Learning` model/migration. I updated the controller `learning_params` to permit `:learned_on`. I updated `index` sorting to use `ORDER BY learned_on DESC, created_at DESC`. I added a `date_field` to `_form.html.erb`. I updated `index` view display.
    Learning: I learned that using SQL default `CURRENT_DATE` is effective for database-level defaults upon record creation. However, for new, unsaved records in a form, a default needs to be set in the view (e.g., `<%= form.date_field :learned_on, value: Date.today %>`) or controller (`@learning = Learning.new(learned_on: Date.today)`).
  BODY
  "feature,rails-core,model,migration,controller,view,form,database,sql,date"
)

create_learning(
  "NoMethodError: undefined method `learned_on` on `new` learning page",
  "2024-04-13",
  <<~BODY,
    Context: The `new.html.erb` view tried to access `@learning.learned_on` to set the default value for the date field (`value: @learning.learned_on || Date.today`), causing `NoMethodError`.
    Resolution: I changed the `date_field` value in the view to just `value: Date.today`. The `@learning` instance created by `LearningsController#new` (`Learning.new`) is unsaved and doesn't have attributes populated from database defaults until saved.
    Learning: I learned to be mindful of when database defaults are applied (on save) versus needing to set defaults explicitly in the controller (`Model.new(attr: default)`) or view (`value: default`) for new object instances presented in forms.
  BODY
  "rails-core,controller,view,form,model,date,nomethoderror,database,default"
)

# --- Session: Apr 14, 2024 ---

create_learning(
  "GitHub Actions CI failing (Rubocop/Importmap missing)",
  "2024-04-14",
  <<~BODY,
    Context: My PR checks failed with errors related to `rubocop` not being found and `bin/importmap` command not existing.
    Resolution:
    *   I uncommented the `rubocop-rails-omakase` gem in the `Gemfile` (group `:development, :test`) to include RuboCop in the bundle for the CI environment.
    *   I corrected the importmap audit command in `.github/workflows/ci.yml` from `bin/importmap audit` to the standard Rails command `bin/rails importmap:audit`.
    Learning: I learned that CI environments install dependencies based strictly on `Gemfile.lock`. I need to ensure all required gems (especially for linting/testing steps) are included in the correct groups. I also learned to double-check the exact commands used in CI workflows against standard Rails commands or existing binstubs.
  BODY
  "deployment-ci,environment-setup,workflow"
)

create_learning(
  "Subsequent CI failures (Rubocop style / Importmap command)",
  "2024-04-14",
  <<~BODY,
    Context: After fixing initial errors, CI failed again. Rubocop reported style violations (whitespace, empty lines), and `bin/rails importmap:audit` resulted in an "Unrecognized command" error.
    Resolution:
    *   Rubocop: I decided to run `rbenv exec bundle exec rubocop -A` locally before committing to auto-correct style violations. I added this as a step in `PLANNING.md`/`README.md`.
    *   Importmap Audit: I changed the command in `.github/workflows/ci.yml` to `bundle exec rails importmap:audit` to ensure the task runs within the correct bundle context.
    Learning: Regularly running the linter (`rubocop -A`) locally prevents style errors from reaching CI. I learned that using `bundle exec` before Rails/Rake tasks in CI can sometimes resolve environment or command recognition issues by ensuring the command runs within the context of the installed gems.
  BODY
  "deployment-ci,workflow,environment-setup"
)

create_learning(
  "Persistent CI failure: `importmap:audit` task not found",
  "2024-04-14",
  <<~BODY,
    Context: The CI job `scan_js` consistently failed with errors indicating the task `importmap:audit` could not be found or run, even using `rails`, `rake`, or `bundle exec`.
    Resolution: I verified locally using `rake -T | grep importmap` that the `importmap:audit` task was not available in my project's current setup (Rails version, `importmap-rails` version). I removed the entire `scan_js` job from `.github/workflows/ci.yml`.
    Learning: Before troubleshooting CI command failures extensively, I learned to verify that the command/task actually exists and is available in my project's specific gem/framework versions (`rake -T`, `rails -T`). I shouldn't assume standard template tasks are always applicable or available.
  BODY
  "deployment-ci,workflow,environment-setup"
)

create_learning(
  "Feature: Implemented tag filtering",
  "2024-04-14",
  <<~'BODY',
    Action: I implemented the tag filtering feature.
    Details: I added a `tag_list` helper to the `Learning` model (simple `tags.split(',').map(&:strip)`). I updated `LearningsController#index` to filter by `params[:tag]` (`where("tags LIKE ?", "%#{params[:tag]}%")`) and collect unique tags for the view (`Learning.pluck(:tags).flat_map { |t| t.split(',') }.uniq`). I updated `index.html.erb` with a `turbo_frame_tag` around the list, clickable tag links (`link_to tag, learnings_path(tag: tag)`), and filter controls. I added basic CSS styling for tags.
    Learning: I learned that simple string-based tags (comma-separated) can be made functional for filtering using basic Rails querying (`LIKE` or `string_to_array` in PG) and Turbo Frames for efficient UI updates without full page reloads, adhering to the 37signals principle of starting simple.
  BODY
  "feature,rails-core,model,controller,view,tags,filtering,turbo,hotwire,sql,like,css,ui,37signals"
)

create_learning(
  "Request spec failure (`render_template` matcher missing)",
  "2024-04-14",
  <<~BODY,
    Context: My request spec failed: `Failure/Error: expect(response).to render_template(:new) ... assert_template has been extracted to a gem. To continue using it, add `gem 'rails-controller-testing'` to your Gemfile.` The `render_template` matcher in RSpec request specs relies on functionality (`assert_template`) that is no longer part of Rails core.
    Resolution: I added `gem 'rails-controller-testing'` to the `:test` group in the `Gemfile` and ran `bundle install`.
    Learning: I learned to be aware that testing helpers previously included in Rails core might be extracted into separate gems in newer versions. Error messages usually indicate the required gem (`rails-controller-testing` for `render_template`, `assigns`, `assert_template`).
  BODY
  "testing,rails-core,rspec,request-spec,dependencies,gem,controller-testing,gemfile"
)

create_learning(
  "Request spec failures (`StaticPages` 404s)",
  "2024-04-14",
  <<~BODY,
    Context: My request specs failed: `StaticPages GET /... returns http success` failed with `Expected response to be a <2XX: success>, but was a <404: Not Found>`. This occurred for `/home`, `/hire_me`, `/about` specs in `spec/requests/static_pages_spec.rb`. The specs were using hardcoded string paths (e.g., `get "/static_pages/home"`) that didn't match the actual routes defined in `config/routes.rb`.
    Resolution: I updated the specs to use the correct Rails path helpers (`get root_path`, `get hire_me_path`, `get about_path`) defined by `config/routes.rb`.
    Learning: I learned to always use Rails path helpers (e.g., `root_path`, `learnings_path`, `hire_me_path`) in request/system specs instead of hardcoding URL strings. This ensures tests remain accurate even if routes change and avoids simple 404 errors. Using `rails routes` helps check available helpers.
  BODY
  "testing,rails-core,rspec,request-spec,routes,path-helpers,configuration"
)

create_learning(
  "Observation: Pending model specs for `Learning`",
  "2024-04-14",
  <<~BODY,
    My Observation: RSpec reported pending examples for `spec/models/learning_spec.rb`.
    Context: The generated model spec file contains a placeholder pending test (`pending "add some examples to (or delete) #{__FILE__}"`).
    Resolution: Needs implementation of model tests (e.g., for validations) as per `TASK.md`.
    Learning: Pending specs are reminders from RSpec to write tests for specific files/contexts. They don't indicate errors but highlight missing test coverage. I need to address them by writing tests or removing the spec file if not needed.
    Next Step: Implement tests for `title` and `body` presence validations, and optionally for the `tag_list` helper method.
  BODY
  "testing,workflow"
)

create_learning(
  "Initial Render deployment failed (Static Site vs Web Service)",
  "2024-04-14",
  <<~BODY,
    Context: My initial deployment attempt on Render using the Static Site service type failed. The Static Site service type is only for pre-built HTML/CSS/JS files and does not run a backend server process like Rails requires (Puma).
    Resolution: I deleted the Static Site service and created a new Web Service on Render.
    Learning: Rails applications require a dynamic backend environment capable of running a server process (like Puma). I learned to use Render's "Web Service" type, not "Static Site", for deploying my Rails app.
  BODY
  "deployment-ci,rails-core"
)

create_learning(
  "Render build failures (`DatabaseNotDefined`)",
  "2024-04-14",
  <<~BODY,
    Context: My builds failed related to database configuration (`ActiveRecord::DatabaseConfigurations::DatabaseNotDefined: Database configuration "'default'" not defined`). The default `config/database.yml` included a complex multi-database production setup that was incompatible with Render's standard `DATABASE_URL` environment variable approach.
    Resolution: I simplified the `production:` block in `config/database.yml` to inherit defaults and rely solely on the `DATABASE_URL` environment variable provided by Render (e.g., `production:\n  <<: *default\n  url: <%= ENV['DATABASE_URL'] %>`). Rails 7+ often handles `DATABASE_URL` automatically if the production block is simple enough or just inherits defaults.
    Learning: For standard PaaS deployments (like Render, Heroku), I learned to configure the `production` database section in `config/database.yml` to use the `DATABASE_URL` environment variable provided by the host. Avoid complex hardcoded setups unless explicitly needed and configured on the host. Rely on Rails conventions.
  BODY
  "deployment-ci,database,environment-setup"
)

create_learning(
  "Render deployment stuck (Puma in Build Command)",
  "2024-04-14",
  <<~BODY,
    Context: My deployment got stuck after adding `puma` to the Build Command in Render settings. The `puma` command starts a long-running server process, but the Build Command expects tasks that finish (like `bundle install`, `assets:precompile`).
    Resolution: I removed `puma` from the Build Command and placed it in the dedicated Start Command field in Render's Web Service settings (e.g., `bundle exec puma -C config/puma.rb`).
    Learning: I learned to distinguish between Build Commands (setup tasks that complete, e.g., installing dependencies, compiling assets) and Start Commands (long-running server processes) in deployment platform configurations like Render.
  BODY
  "deployment-ci,workflow"
)

create_learning(
  "Render runtime errors (`ActiveRecord::ConnectionNotEstablished` - Socket)",
  "2024-04-14",
  <<~BODY,
    Context: I encountered runtime errors (`ActiveRecord::ConnectionNotEstablished`) trying to connect via local socket (`/var/run/postgresql/.s.PGSQL.5432`). Despite `config/database.yml` being configured for `DATABASE_URL`, Rails was not running in the `production` environment, causing it to default to socket connections defined elsewhere in `database.yml` (likely development).
    Cause 1: The Start Command initially included `-e ${RACK_ENV:-development}` or similar, overriding the production setting.
    Cause 2: The `RAILS_ENV` environment variable was missing or incorrect in Render.
    Cause 3: Puma reported `Environment: development` or `deployment` even with `RAILS_ENV=production` set, suggesting `RACK_ENV` might take precedence or another override was present.
    Resolution:
    *   I changed the Start Command to `bundle exec puma -C config/puma.rb` (removing explicit `-e`).
    *   I explicitly added both `RAILS_ENV=production` and `RACK_ENV=production` environment variables in Render's UI.
    Learning: I learned to ensure the Rails environment is correctly set to `production` on the deployment server via `RAILS_ENV` (primary) and potentially `RACK_ENV` environment variables. I need to verify the environment Puma/Rails reports in the logs and check the Start Command for overrides.
  BODY
  "deployment-ci,database,environment-setup"
)

create_learning(
  "Render: Continued socket errors (Missing `DATABASE_URL`)",
  "2024-04-14",
  <<~BODY,
    Context: I continued to see socket connection errors even with the `production` environment confirmed. The `DATABASE_URL` environment variable itself was missing from the Web Service configuration.
    Cause: The Render PostgreSQL database service was not automatically linked to the Web Service when I created it, or the link was broken/not established. Render doesn't always automatically inject the `DATABASE_URL` from a linked DB into the web service environment.
    Resolution: I manually located the database 'Internal Connection String' from the database service's page in Render and added it as the `DATABASE_URL` environment variable to the Web Service settings.
    Learning: I learned to verify that the `DATABASE_URL` environment variable exists and is correctly populated in the deployment environment. If using linked services (like Render databases), I need to ensure the link is active and injecting the variable, or manually provide the connection string if necessary.
  BODY
  "deployment-ci,database,environment-setup"
)

create_learning(
  "Render: Running initial migrations on free tier (Build Command workaround)",
  "2024-04-14",
  <<~BODY,
    Context: I needed to run initial database migrations (`rails db:migrate`) on Render's free tier, which lacks Shell access or explicit Pre-Deploy/Post-Deploy command support. Migrations must run after the code is deployed and dependencies installed but before the server starts taking requests based on the new schema.
    Resolution (Workaround): I temporarily added `bundle exec rails db:migrate` to the *end* of the Build Command in Render settings for the first successful deployment (e.g., `bundle install; bundle exec rails assets:precompile; bundle exec rails db:migrate`).
    Learning: On restricted environments (like PaaS free tiers), essential post-deploy tasks like database migrations might need temporary workarounds, such as including them at the end of the build command. I learned to remember to remove the migration step from the build command after the first successful run to avoid unnecessary migrations on subsequent deploys and potentially slow down builds. Considering using release phase tasks if the platform supports them (Render paid tiers do) is a good idea for the future.
  BODY
  "deployment-ci,database,migration,workflow"
)

# --- Session: Apr 15, 2024 ---

create_learning(
  "`FactoryBot::DuplicateDefinitionError` on dev server startup",
  "2024-04-15",
  <<~BODY,
    Context: My development server (`./bin/dev`) failed to boot, reporting `FactoryBot::DuplicateDefinitionError: Factory already registered: learning`.
    Cause: The `factory_bot_rails` gem was included in the `group :development, :test do` block in the `Gemfile`. This caused FactoryBot's Railtie to load factory definitions (`spec/factories/*.rb`) during development environment initialization (e.g., via Spring or initial boot), potentially conflicting with other initializers or running twice.
    Resolution: I moved `gem "factory_bot_rails"` exclusively to the `group :test do` block in the `Gemfile` and ran `rbenv exec bundle install`.
    Learning: I learned that gems intended solely for testing (like `factory_bot_rails`, `shoulda-matchers`, `capybara`) should typically only be included in the `:test` group in the `Gemfile`. Including them in `:development` can lead to unexpected behavior, errors during server startup, or unnecessary loading as their initializers might run inappropriately or cause conflicts.
  BODY
  "testing,dependencies,factorybot,gemfile,environment-setup,workflow"
)

create_learning(
  "Clarification: Use `./bin/dev` not `rbenv exec bin/dev`",
  "2024-04-15",
  <<~BODY,
    Context: I clarified in `README.md` that `./bin/dev` is the preferred command to start the development server, after confirming `rbenv exec bin/dev` causes issues (previously logged Apr 8 & Apr 13).
    Resolution: I updated `README.md` to reflect `./bin/dev` as the primary command and added a note about specifying the `PORT` environment variable if needed (e.g., `PORT=8000 ./bin/dev`).
    Learning: I learned to ensure documentation (`README.md`, `PLANNING.md`) accurately reflects the working commands discovered during troubleshooting and development, including common variations like specifying a port or necessary environment variables. Keeping documentation consistent with learned best practices for my specific project environment is important.
  BODY
  "workflow,documentation,readme,rbenv,bin/dev,environment-setup"
)

# --- Session: Apr 19, 2025 --- Note: Year seems incorrect in log, assuming 2024

create_learning(
  "Deployed changes (Edit link) not appearing on Render",
  "2024-04-19", # Assuming 2024 based on context
  <<~BODY,
    Context: A newly added "Edit" link for learnings appeared locally but not on my deployed Render application, despite logs showing the correct commit deployed and server restarted.
    Resolution: I modified the Build Command in Render settings. I changed the order of asset tasks from `...; bundle exec rake assets:precompile; bundle exec rake assets:clean; ...` to `...; bundle exec rake assets:clean; bundle exec rake assets:precompile; ...`. Redeploying with `clean` before `precompile` made the link appear.
    Learning: The order of asset pipeline tasks in the build command matters, especially with tools like Sprockets or Propshaft. I learned that running `assets:clean` *before* `assets:precompile` ensures that stale or conflicting assets from previous builds are removed before new ones are generated. This prevents potential issues where old assets (CSS, JS) might be served by the CDN or web server, causing new code changes or UI elements not to appear as expected in the production environment.
  BODY
  "deployment-ci,frontend,workflow"
)

# --- Session: Apr 19, 2024 (Delete Button UI/UX) ---

create_learning(
  "Incorrect element movement broke layout (`form_with`/Turbo)",
  "2024-04-19",
  <<~BODY,
    Task: Move "Delete Selected" button to top, next to "Log New Learning".
    Issue: Initial attempt incorrectly moved the entire learnings list (which was inside the `form_with`) along with the button form, breaking the layout significantly.
    Resolution: I reverted the changes and restructured the view (`learnings/index.html.erb`). I moved only the submit button (`<input type="submit">`) into the top `.actions` div. Then, I ensured the main `form_with` tag wrapped the entire area containing both the actions/button *and* the list with checkboxes.
    Learning: I learned to be careful when moving elements within complex form structures (`form_with`), especially those interacting with Turbo Frames or Streams. I need to ensure only the intended element is relocated and that the form still correctly encompasses all necessary inputs (checkboxes, submit button). Incorrect nesting can break form submission or layout.
  BODY
  "frontend,ui,ux,layout,html,css,rails,view,form_with,turbo"
)

create_learning(
  "Stimulus controller not executing (dynamic button disable)",
  "2024-04-19",
  <<~BODY,
    Issue: Despite seemingly correct Stimulus controller (`selection_controller.js`) setup, HTML attributes (`data-controller`, `data-action`, `data-target`), and CSS, the "Delete Selected" button remained disabled even when I checked items.
    Context: Extensive troubleshooting performed: Verified controller registration (`stimulus:manifest:update`, `controllers/index.js`), `javascript_importmap_tags` in layout, `controllers/application.js` initialization. Added `console.log` statements; logs did not appear in the browser console, indicating the controller code was not executing. Tested moving `data-controller` scope. Checked for conflicts/errors.
    Resolution: Due to the inability to diagnose why the Stimulus controller wasn't connecting/executing, I reverted the dynamic disabling feature for simplicity. I deleted the controller file, removed the registration, cleaned the `data-` attributes from view/layout, and removed CSS styles.
    Learning: If JavaScript behavior (especially Stimulus) fails without obvious errors after checking standard setup (loading, registration, attributes, initialization, console logs), I learned to consider potential deeper issues: asset pipeline problems, JS bundling errors (check network tab/console thoroughly), subtle DOM interactions (e.g., Turbo Frames replacing elements Stimulus was connected to), typos in `data-` attributes or controller identifiers, or timing issues. Sometimes reverting to a simpler solution is pragmatic if debugging proves too complex or time-consuming for the feature's value.
  BODY
  "frontend,javascript,stimulus,hotwire,debugging,asset-pipeline,turbo,dom,error"
)

create_learning(
  "Visual inconsistency between `<a>` link and `<input type='submit'` button",
  "2024-04-19",
  <<~BODY,
    Issue: "Log New Learning" link (`<a>` styled as button) and "Delete Selected" button (`<input type="submit">`) had slightly different heights/widths despite sharing similar CSS class (`.button`).
    Resolution: I added explicit `box-sizing: border-box;`, `line-height: 1.5;`, and `vertical-align: middle;` to the shared CSS rule targeting both `.button` and `input[type="submit"]`.
    Learning: I learned that link tags (`<a>`) and submit inputs (`<input type="submit">`) can have slightly different default browser rendering regarding padding inclusion (`box-sizing`), line height, and vertical alignment. Explicitly setting these properties in CSS ensures visual consistency when styling different HTML element types to look like buttons.
  BODY
  "frontend,ui,ux,css,html,css-alignment,button,form,box-sizing"
)

# --- Session: Apr 19, 2024 (Form UI/UX & Asset Pipeline) ---

create_learning(
  "Task: Refine 'Log New Learning' form UI/UX",
  "2024-04-19",
  <<~BODY,
    Task: Refine the UI/UX of the "Log New Learning" form (`learnings/_form.html.erb`) to align with 37signals principles (better spacing, guidance, alignment, font consistency).
    Details: I focused on using standard Rails helpers, hand-crafted CSS, and HTML attributes (`placeholder`) for clear guidance, consistent spacing/fonts, and alignment with the index page layout. I used the `_form.html.erb` partial.
    Learning: Good form UI involves clear labels, helpful placeholders, logical grouping (`.form-group`), consistent spacing/typography, and alignment with surrounding page elements. Using partials for DRY forms is good practice.
  BODY
  "frontend,ui,ux,css,html,rails,view,form,form_with,partial,37signals"
)

create_learning(
  "CSS changes not reflected (Asset Pipeline/Cache/HTML issue)",
  "2024-04-19",
  <<~BODY,
    Issue: CSS changes I added to `application.css` for form styling were not reflected in the browser despite server restarts and hard refreshes.
    Troubleshooting Steps: I verified CSS file content. Checked browser Network tab (saw `200 OK (from memory cache)`, indicating stale cache). Ran `rbenv exec rails assets:clobber` and restarted/refreshed; still no change. Verified `stylesheet_link_tag` in layout. Verified asset pipeline gem (`propshaft`). Checked for potential `Procfile.dev`/`manifest.js` issues (none found/needed for Propshaft dev). Re-inspected CSS/HTML.
    Resolution: I found that the required HTML structure changes (adding classes like `form-container`, `form-group`, placeholders) in `_form.html.erb` were missing/had been reverted. Re-applying the necessary HTML changes resolved the issue.
    Learning: When CSS doesn't apply as expected, I learned to double-check *both* the CSS *and* the HTML structure it targets. Asset pipeline issues (caching) can occur, but often the root cause is simpler: the HTML/CSS edits weren't applied correctly or completely in the first place. `rails assets:clobber` is a key tool for suspected CSS/JS caching issues in development. Propshaft in development typically serves assets directly without complex manifests.
  BODY
  "frontend,css,debugging,asset-pipeline,propshaft,cache,html,workflow,assets,clobber"
)

create_learning(
  "Form content indented compared to index page",
  "2024-04-19",
  <<~BODY,
    Issue: My form content (`.form-container`) was slightly indented horizontally compared to the index page content.
    Cause: The `.form-container` CSS rule had horizontal padding (`padding: 0 1rem;`) while the index page content relied on the body's margin or a container without that specific padding.
    Resolution: I removed the horizontal padding (`padding: 0 1rem;`) from the `.form-container` CSS rule to align it with the index page's container.
    Learning: I learned to ensure consistent container padding/margins across different page templates or layouts for visual alignment and a cohesive look. Inspecting element styles using browser dev tools is helpful.
  BODY
  "frontend,ui,ux,css,layout,css-alignment,padding,margin"
)

create_learning(
  "Textarea font different from input fields",
  "2024-04-19",
  <<~BODY,
    Issue: The font in the `textarea` (body field) differed from `input` fields (e.g., title).
    Cause: Textareas often default to a monospace font in browsers, while other inputs might inherit the body font. The shared CSS rule for inputs/textarea didn't explicitly set `font-family`.
    Resolution: I added `font-family: inherit;` to the shared CSS rule for `input, textarea`.
    Learning: I learned to explicitly set `font-family: inherit;` on form controls (`input`, `textarea`, `select`, `button`) to ensure they consistently use the base font defined higher up in the CSS cascade (e.g., on `body`), avoiding default browser discrepancies.
  BODY
  "frontend,ui,ux,css,html,form,font,textarea,input"
)

create_learning(
  "Discussion: Native `date_field` vs alternatives",
  "2024-04-19",
  <<~BODY,
    Discussion: I considered alternatives to the native HTML5 `date_field` due to inconsistent styling/icon placement across browsers (Chrome vs Firefox vs Safari).
    Alternative Considered: Rails `date_select` helper (outputs three dropdowns: Year, Month, Day). Custom JS date pickers were ruled out by the 37signals philosophy.
    Decision: I stuck with `date_field` for simplicity and reliance on native browser behavior, accepting the minor cross-browser styling limitations. I added `(YYYY-MM-DD)` format hint to the label for clarity, as placeholder text isn't supported consistently for date inputs.
    Learning: Native form elements offer simplicity, accessibility, and avoid JS dependencies but have limited styling control. I learned to weigh the trade-offs between custom solutions (more control, more complexity/JS) and accepting native limitations based on project philosophy (e.g., 37signals favors simplicity and defaults). Providing clear labels and format hints is important.
  BODY
  "frontend,ui,ux,html,css,form,date,date_field,date_select,accessibility,browser-compatibility,37signals,decision"
)

# --- Session: Apr 20, 2024 ---

create_learning(
  "`rails db:seed` failed (NameError due to heredoc interpolation)",
  "2024-04-20",
  <<~'BODY', # Using non-interpolating heredoc here too, just in case.
    Context: I ran the generated seed script which populated `Learning` records from `LEARNINGS.md`. The error occurred processing an entry whose body contained the literal text `params[:tag]`. The default heredoc syntax (`<<~BODY`) attempted Ruby interpolation (`#{...}`) on this text, causing `NameError: undefined local variable or method 'params' for main:Object`.
    Resolution: I changed the heredoc definition for the problematic entry in `db/seeds.rb` from `<<~BODY` to `<<~'BODY'` (note the single quotes). This prevents interpolation within that specific string, treating it literally.
    Learning: I learned to be cautious when using interpolating heredocs (`<<~DELIMITER`) in seed files or scripts if the source text might contain `#{}`, `${}`, or similar sequences that could be misinterpreted as code interpolation. Use non-interpolating heredocs (`<<~'DELIMITER'`) or escape the relevant characters (`\#{}`) within the string if interpolation is needed elsewhere but not for specific literals.
  BODY
  "seeds,database,ruby,heredoc,interpolation,error,debugging,workflow"
)

create_learning(
  "Seeded text displayed raw HTML & unstyled backticks",
  "2024-04-20",
  <<~'BODY',
    Context: The `format_learning_body` helper used `sanitize: false` to preserve `<strong>` tags, but this also allowed other raw HTML from the source text (like `<input>`) to render. Backticks (`) were preserved but had no special styling.
    Resolution: I modified the `format_learning_body` helper:
    1. Escape all HTML first (`ERB::Util.html_escape`).
    2. Bold keywords (`<strong>`) on escaped string.
    3. Wrap backticked content (`) with `<code>` tags on bolded string.
    4. Apply `simple_format(..., sanitize: false)` last.
    5. Added CSS for `code` tag.
    Learning: When displaying potentially unsafe text that also needs specific safe HTML formatting, I learned the order matters: Escape first, then selectively add safe tags, then apply structural formatting (like `simple_format` with `sanitize: false`).
  BODY
  "seeds,formatting,view,helper,html,css,escaping,sanitization,code,bold,frontend,debugging"
)

# --- Session: Apr 21, 2024 ---

create_learning(
  "CSS Layout Fix: Form container width",
  "2024-04-21",
  <<~'BODY',
    Issue: My form pages (`/learnings/new`, edit) appeared narrow after CSS cleanup.
    Context: Applying `max-width: 700px;` to the `.form-container` class during CSS refactoring restricted the entire form area.
    Resolution: I removed the `max-width: 700px;` rule from `.form-container` in `application.css`.
    Learning: I learned to be mindful of the layout impact of CSS rules like `max-width` on containers. Testing responsiveness and appearance after changes is important.
  BODY
  "css,layout,frontend,ui,ux,debugging,css-cleanup"
)

create_learning(
  "Clarification: Turbo's data-turbo-confirm attribute",
  "2024-04-21",
  <<~'BODY',
    Context: We discussed the purpose of `data-turbo-confirm` attribute.
    Explanation: It's a Hotwire/Turbo HTML attribute (`data-turbo-confirm="Are you sure?"`) that automatically triggers a browser confirmation dialog before executing a link click or form submission.
    Use Case: Commonly used for destructive actions (like deletion) to prevent accidental clicks.
    Learning: I learned to utilize standard Hotwire/Turbo attributes for common UX patterns like confirmation dialogs with minimal effort.
  BODY
  "hotwire,turbo,javascript,frontend,ui,ux,html,attribute"
)

create_learning(
  "Clarification: CSS Styling Consolidation Effects",
  "2024-04-21",
  <<~'BODY',
    Context: We discussed visual changes after my CSS cleanup (buttons, fonts, tags).
    Buttons: Change to blue (`#007bff`) resulted from my consolidating multiple previous rules for `.button` and `input[type="submit"]` into one consistent style for simplicity.
    Fonts: Adding `font-family: inherit;` to form inputs/textareas ensures they use the main body font stack, improving consistency.
    Tags: Change from pill-shaped (`border-radius: 10rem;`) to squared (`border-radius: 4px;`) was part of my cleanup for a cleaner look.
    Learning: CSS consolidation aims for simplicity but can alter appearance. I learned that explicit styles (`font-family: inherit;`) prevent varying browser defaults. Intentional style changes should be noted.
  BODY
  "css,frontend,ui,ux,refactoring,button,font,tags,consistency,css-cleanup"
)

# --- Session: Apr 22, 2024 ---

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
  "rails-core,environment-setup,frontend,error-handling,debugging"
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
  "frontend,workflow,debugging"
)

create_learning(
  "Using `mail_to` helper for email links",
  "2024-04-22",
  <<~'BODY',
    Decision: I changed the static email address text on the Hire Me page to a clickable `mailto:` link using the Rails `mail_to` helper (`<%= mail_to "email@example.com" %>`).
    Reason: Improves usability by allowing users to click the link to open their default email client. The `mail_to` helper is preferred over a raw HTML `mailto:` link as it can offer minor obfuscation against simple bots and is the conventional Rails way.
    Learning: I learned to use the `mail_to` view helper in Rails to generate clickable email links for better user experience and adherence to Rails conventions.
  BODY
  "rails-core,frontend"
)

create_learning(
  "Refining 'Hire Me' page narrative (Honesty vs. Potential)",
  "2024-04-22",
  <<~'BODY',
    Context: I revised the content of the `hire_me.html.erb` page to more accurately reflect my journey and experience level for the 37signals Junior Developer role.
    Strategy: I moved away from implying extensive prior Rails experience. Instead, I explicitly stated that my professional Rails experience is limited but framed the TIL Tracker project itself as strong evidence of my rapid learning, problem-solving under pressure, ability to adopt the 37signals way, and high motivation. I emphasized transferable skills from my previous roles (data analysis, communication).
    Learning: When applying for roles, especially stretch roles, I learned that honesty about specific experience gaps combined with a clear demonstration of my learning ability, relevant transferable skills, and genuine enthusiasm/alignment with the company's values can be a very effective narrative. Framing my projects as direct responses to the application requirements strengthens the message.
  BODY
  "project-management"
)

create_learning(
  "Database Reset Issues & `db:seed:replant` Workaround on Render",
  "2024-04-23", # Assuming today's date
  <<~'BODY',
    Context: My learnings changes in `seeds.rb` weren't reflected on Render, even after deploying with `db:migrate; db:seed` in the Pre-Deploy command. I needed a way to ensure a fresh seed.
    Attempt 1 (`db:reset` in shell): Running `DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:reset` in the Render shell failed with `PG::ObjectInUse` because active web server connections prevented dropping the database.
    Attempt 2 (Terminate connections): Trying `SELECT pg_terminate_backend(...)` from `rails dbconsole` failed with permission errors, as my application user lacked `SUPERUSER` rights.
    Attempt 3 (Scale down): Scaling the web service instances to 0 didn't work either (reason unclear).
    Successful Workaround (`db:seed:replant`): Using `DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:seed:replant` in the Pre-Deploy Command field for *one* deployment successfully reset the data. This command truncates the relevant tables before seeding.
    Learning: `db:reset` is difficult on Render without SUPERUSER privileges or reliably stopping connections. `db:seed:replant` can force a reset in the pre-deploy step but is destructive and must be removed immediately after use. The standard `db:migrate; db:seed` (using `find_or_create_by!`) is the safe, idempotent command for regular deploys, ensuring data in `seeds.rb` is present/updated without deleting other records.
  BODY
  "deployment-ci,database,seeds,render,debugging,workflow,reset,replant"
)

puts "Finished seeding Learnings."
puts "Created/verified #{Learning.count} learning entries."
