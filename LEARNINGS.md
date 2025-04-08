# Learnings & Issues Log

This file tracks issues encountered, solutions applied, and general learnings during the development of the TIL Tracker app.

## Session: Apr 8, 2024

1.  **Issue:** `rbenv: bin/dev: command not found` when using `rbenv exec bin/dev`.
    *   **Context:** Attempting to start the Rails development server using the project's specified command style (`rbenv exec ...`).
    *   **Resolution:** Found that running `./bin/dev` directly works correctly. The script's shebang (`#!/usr/bin/env ruby`) combined with the existing `rbenv` shim setup ensures the correct Ruby version is used without needing the `rbenv exec` prefix for this specific script. The prefix was causing an execution issue.
    *   **Learning:** `rbenv exec` might not always be necessary or beneficial if the target script and shell environment (shims, PATH) are already correctly configured to find the intended Ruby version. In some cases, it can interfere. The project convention was updated in `PLANNING.md` to note this specific case might not require the prefix.

2.  **Issue:** Rails generator failed for model name `Til` (`The name 'Til' is either already used...`).
    *   **Context:** Trying to generate the primary model for the application as `Til`.
    *   **Resolution:** Switched to using the name `Learning` for the model and `LearningsController` for the associated controller. Generated these components successfully and removed the previous partially generated/conflicting `Til` files and migration. Updated `TASK.md` and `routes.rb` accordingly.
    *   **Learning:** Be aware of potential naming collisions with Rails internals or reserved words, even if not strictly listed. Choosing a slightly more descriptive or different name can avoid generator issues.

3.  **Issue:** Rails generator failed for `StaticPagesController` due to name collision.
    *   **Context:** Attempting to generate `StaticPagesController` as per `TASK.md`.
    *   **Resolution:** Realized the controller already existed (likely from initial `rails new` or prior steps). Verified the existing controller contained the necessary actions (`home`, `hire_me`, `about`).
    *   **Learning:** Confirm whether components exist before running generators, especially when resuming work or working from a task list, to avoid simple errors.

## Session: Apr 9, 2024

1.  **Issue:** Initial confusion about the project root directory.
    *   **Context:** The AI initially looked for files in the workspace root (`/Users/danildanilov/Documents/GitHub/ruby-app-37s`) instead of the project directory (`/Users/danildanilov/Documents/GitHub/ruby-app-37s/til_tracker`).
    *   **Resolution:** User clarified the correct path. Added a note to `PLANNING.md` specifying `til_tracker` as the project root.
    *   **Learning:** Always confirm the project's subdirectory structure within the workspace, especially if not at the top level. Update planning docs accordingly.

2.  **Issue:** `NoMethodError: undefined method 'pluralize' for #<LearningsController:...>` when deleting learnings.
    *   **Context:** The `destroy_multiple` action in `LearningsController` tried to use the `pluralize` helper directly.
    *   **Resolution:** Changed the call to `view_context.pluralize` to access the view helper from the controller.
    *   **Learning:** View helpers like `pluralize` are part of `ActionView` and must be accessed via `view_context` when called from within a controller.

3.  **Issue:** `brew services start postgresql` failed (`Formula 'postgresql@14' is not installed`).
    *   **Context:** Trying to start the database service required by the Rails app.
    *   **Resolution:** Installed PostgreSQL using `brew install postgresql`, then started the specific versioned service with `brew services start postgresql@14`.
    *   **Learning:** Ensure required background services (like databases) are installed via the package manager (Homebrew) before attempting to start them. Verify the correct formula name if using versioned formulas.

4.  **Issue:** `bundle install` failed (`Could not locate Gemfile`).
    *   **Context:** Running `bundle install` from the parent directory (`ruby-app-37s`) instead of the project root.
    *   **Resolution:** Changed directory to `til_tracker` before running `bundle install`.
    *   **Learning:** Always run commands like `bundle install` or `rails` from the root directory of the specific Rails project.

5.  **Issue:** `bundle install` failed (`Could not find 'bundler' (2.6.7) required by ... Gemfile.lock`).
    *   **Context:** The Ruby version active (initially system Ruby 2.6) did not have the specific `bundler` gem version required by the project installed.
    *   **Resolution:** Attempted `gem install bundler:2.6.7`.
    *   **Learning:** Projects lock specific bundler versions in `Gemfile.lock`. The active Ruby environment must have this bundler version installed.

6.  **Issue:** `gem install bundler:2.6.7` failed (`Gem::FilePermissionError` for `/Library/Ruby/Gems/2.6.0`).
    *   **Context:** The shell was using the system Ruby (2.6.x), and installing gems globally requires permissions and is generally discouraged. The project's `.ruby-version` specified 3.2.2.
    *   **Resolution:** Identified that `rbenv` was installed but not properly activated in the shell environment (`PATH` configuration issue in `.zshrc`).
    *   **Learning:** Use a Ruby version manager (`rbenv`) to handle project-specific Ruby versions and avoid modifying the system Ruby installation. Ensure the version manager is correctly initialized in the shell configuration (`.zshrc`).

7.  **Issue:** `rbenv` installed but not activating correctly (`ruby -v` showed system Ruby, `which gem` showed system gem).
    *   **Context:** The `rbenv init` command in `.zshrc` was not correctly modifying the `PATH` to prioritize `rbenv` shims, potentially due to conflicts or ordering issues within the `.zshrc` file.
    *   **Resolution (Temporary):** Manually prepended the shims directory for the current session: `export PATH="$HOME/.rbenv/shims:$PATH"`.
    *   **Resolution (Workaround):** Followed the `PLANNING.md` convention of using `rbenv exec` before `bundle` and `rails` commands (e.g., `rbenv exec bundle install`, `rbenv exec rails db:create`).
    *   **Resolution (Permanent Fix Needed):** `.zshrc` still requires investigation to ensure `rbenv init` works correctly on shell startup.
    *   **Learning:** Correct shell integration is crucial for `rbenv`. Check `PATH` and `.zshrc` initialization order if versions aren't switching automatically. `rbenv exec` is a reliable workaround if shell integration is problematic.

8.  **Issue:** `rbenv exec bin/dev` failed initially.
    *   **Context:** Command run from the wrong directory and `bin/dev` potentially lacked execute permissions.
    *   **Resolution:** Added execute permissions (`chmod +x til_tracker/bin/dev`), changed to the `til_tracker` directory, and reran `rbenv exec bin/dev`.
    *   **Learning:** Ensure scripts have necessary permissions (`+x`) and are executed from the correct working directory relative to the project structure.

9.  **Issue:** `rails new` failed during initial `bundle install` (`ERROR: Failed to build gem native extension.` for `pg` gem).
    *   **Context:** The `pg` gem requires the PostgreSQL client library (`libpq`) to build its native C extension.
    *   **Resolution:** Installed the client library using `brew install libpq`.
    *   **Learning:** Native extensions for gems often depend on external system libraries. Read the error messages carefully, as they usually suggest the required package and installation command (e.g., via Homebrew).

10. **Issue:** Subsequent `bundle install` failed (`Could not find 'bundler' (2.6.7) ...`).
    *   **Context:** Even after installing `libpq`, the shell was still trying to use the system Ruby's environment/bundler version, indicating `rbenv` wasn't fully integrated/activated for the `bundle` command execution.
    *   **Resolution:** Attempted `gem install bundler` directly, which failed with `Gem::FilePermissionError` (again trying to use system Ruby gems location).
    *   **Learning:** Persistent environment issues suggest deeper problems with shell initialization (`.zshrc`) or PATH order. Verified `rbenv` path was missing.

11. **Issue:** `rbenv` PATH missing, `gem install bundler` still fails with permission error.
    *   **Context:** `rbenv init` in `.zshrc` likely placed incorrectly, preventing shims from being added to the PATH early enough.
    *   **Resolution (Workaround):** Used `rbenv exec gem install bundler` to successfully install bundler within the correct Ruby 3.2.2 context.
    *   **Learning:** `rbenv exec` forces the command to run within the context of the selected `rbenv` version, bypassing potential PATH or shell integration issues. It's a reliable way to ensure the correct Ruby environment is used.

12. **Issue:** `rbenv exec bundle install` failed again on `pg` gem build (`Can't find the 'libpq-fe.h' header`).
    *   **Context:** Although `libpq` was installed via Homebrew, the build process (even when run via `rbenv exec`) didn't know where to find the necessary header files and libraries.
    *   **Resolution:** Explicitly configured Bundler to tell the `pg` gem build process where to find the Homebrew `libpq` installation using `rbenv exec bundle config build.pg --with-pg-config=/opt/homebrew/opt/libpq/bin/pg_config`, followed by `rbenv exec bundle install`.
    *   **Learning:** For gems with native extensions that depend on external libraries installed in non-standard locations (like Homebrew on Apple Silicon), you may need to provide explicit configuration hints to the build process using `bundle config build.<gem_name> --with-<config-option>=/path/to/dependency`.

13. **Issue:** `rbenv exec rails db:create` failed (`ActiveRecord::ConnectionNotEstablished`).
    *   **Context:** The PostgreSQL server was not running or accessible.
    *   **Resolution:** Started the PostgreSQL service (e.g., `brew services start postgresql`).
    *   **Learning:** Ensure required background services like databases are running before Rails attempts to connect to them.