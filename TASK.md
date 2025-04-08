# TIL Tracker App - Tasks

*Self-note: Remember to use `rbenv exec` before rails/bundle/rake commands if the shell environment is still inconsistent.*

## 🚀 Phase 1: Initial Setup & Core Structure (Date: [Current Date])

- [x] Create Rails project (`rails new til_tracker ...`) - Completed [Current Date]
- [x] Fix `pg` gem installation issues (`brew install libpq`, `bundle config`, `rbenv exec bundle install`) - Completed [Current Date]
- [x] Create `PLANNING.md` with project overview, stack, conventions, decisions - Completed [Current Date]
- [x] Create `TASK.md` (this file) - Completed [Current Date]
- [ ] Add `rspec-rails` to `Gemfile` and install - (Assignee: AI)
- [ ] Run `rbenv exec rails generate rspec:install` - (Assignee: AI)
- [ ] Generate `Til` model (`title:string`, `body:text`, `tags:string`) using `rbenv exec` - (Assignee: AI)
- [ ] Generate `StaticPagesController` (`home`, `hire_me`, `about`) using `rbenv exec` - (Assignee: AI)
- [ ] Generate `TilsController` (`index`, `new`, `create`) using `rbenv exec` - (Assignee: AI)
- [ ] Define routes in `config/routes.rb` for all pages - (Assignee: AI)
- [ ] Create initial view files (`.html.erb`) for all actions/pages - (Assignee: AI)
- [ ] Create database (`rbenv exec rails db:create`) - (Assignee: AI)
- [ ] Run migrations (`rbenv exec rails db:migrate`) - (Assignee: AI)
- [ ] Add all generated files to Git and make initial commit - (Assignee: AI)

## 🔬 Phase 2: Feature Implementation

- [ ] Implement Home page (`static_pages#home`) content.
- [ ] Implement Hire Me page (`static_pages#hire_me`) content.
- [ ] Implement About page (`static_pages#about`) content (Optional).
- [ ] Implement TILs list page (`tils#index`).
    - [ ] Display all TILs (title, body, tags, created_at).
    - [ ] Sort by newest first.
    - [ ] Link to create new TIL.
- [ ] Implement New TIL form (`tils#new`).
    - [ ] Build the form using `form_with`.
- [ ] Implement TIL creation (`tils#create`).
    - [ ] Use strong parameters.
    - [ ] Add basic model validations (presence of title, body).
    - [ ] Redirect to `tils#index` on success.
    - [ ] Re-render `tils#new` on validation failure.
- [ ] Add basic styling with Tailwind.

## 🧪 Phase 3: Testing

- [ ] Write model spec for `Til` (validations).
- [ ] Write request spec for `StaticPagesController` (ensure pages load).
- [ ] Write request spec for `TilsController` (index, new, create actions).
    - [ ] Test successful TIL creation.
    - [ ] Test validation failure on TIL creation.
- [ ] Write basic feature spec for creating a TIL (Optional).

## 🧼 Phase 4: Refinement & Documentation

- [ ] Refine UI/UX based on Tailwind.
- [ ] Write `README.md` (summary, screenshots, reflection, setup).
- [ ] Update `PLANNING.md` and `TASK.md` with final decisions/status.

## 🚀 Phase 5: Deployment

- [ ] Choose deployment provider (Fly.io or Render).
- [ ] Configure for deployment.
- [ ] Deploy the application.
- [ ] Verify deployed application works.
- [ ] Add live URL to `README.md`.

## 💡 Discovered During Work
*(Add any new tasks, questions, or blockers that arise here)*
- Shell environment inconsistencies require using `rbenv exec` before Rails/Bundler commands for reliability. Added note to `TASK.md` and command list in `PLANNING.md`.
