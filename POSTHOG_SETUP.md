# PostHog Analytics Integration

This Rails application now includes PostHog analytics integration following the 37signals philosophy with server-rendered HTML and Stimulus controllers.

## What's Implemented

### 1. PostHog Script Integration
- PostHog tracking script loaded in `app/views/layouts/application.html.erb`
- Configured with your API key: `phc_NGXG5TgBucg8nnERvO509IdeXO9VvSZVFrPxv6bQtU4`
- Enabled features: heatmaps, autocapture, pageview tracking, session recording

### 2. Stimulus Controller for Form Tracking
- **File**: `app/javascript/controllers/posthog_controller.js`
- **Purpose**: Track form submissions and user identification
- **Features**:
  - Automatic form submission tracking
  - Email-based user identification
  - Company grouping based on email domain
  - Custom event tracking

### 3. Learning Form Integration
- The learning form (`app/views/learnings/_form.html.erb`) now tracks:
  - Form submissions as `learning_form_submitted` events
  - Form field data (excluding sensitive Rails tokens)
  - Form completion analytics

## Usage Examples

### Basic Form Tracking
Any form can be tracked by adding the PostHog controller:

```erb
<%= form_with model: @model, html: {
  data: {
    controller: "posthog",
    action: "submit->posthog#submit",
    posthog_form_id_value: "contact_form",
    posthog_event_value: "contact_form_submitted"
  }
} do |form| %>
  <!-- form fields -->
<% end %>
```

### Email Identification
For forms with email fields, add the email target:

```erb
<%= form.email_field :email, data: { posthog_target: "email" } %>
```

### Custom Event Tracking
Track custom events anywhere in your views:

```erb
<%# In a link or button %>
<%= link_to "Download PDF", document_path,
    data: {
      controller: "posthog",
      action: "click->posthog#track",
      posthog_event_param: "pdf_download"
    } %>
```

### Programmatic Tracking
In your Stimulus controllers, you can access PostHog directly:

```javascript
// In any Stimulus controller
track() {
  if (window.posthog) {
    window.posthog.capture("button_clicked", {
      button_text: this.element.textContent,
      page: window.location.pathname
    })
  }
}
```

## Configuration

### Company Grouping
The controller includes domain-based company grouping for:
- `automattic.com` → `automattic`
- `posthog.com` → `posthog`

Add more companies in `posthog_controller.js`:

```javascript
const groupDomains = {
  'automattic.com': 'automattic',
  'posthog.com': 'posthog',
  'yourcompany.com': 'yourcompany'  // Add new domains here
}
```

### Events Being Tracked

1. **Automatic Events** (PostHog autocapture):
   - Page views
   - Clicks
   - Form interactions

2. **Custom Events**:
   - `learning_form_submitted` - When users submit learning forms
   - Any custom events you add via the controller

## Privacy & Performance

- PostHog is configured with `person_profiles: 'identified_only'` for privacy
- Session recording is enabled but can be disabled in the layout if needed
- Form data tracking excludes Rails authenticity tokens and internal fields

## Technical Details

- **Framework**: Rails 7+ with Hotwire/Stimulus
- **JavaScript**: Uses importmap for dependency management
- **Philosophy**: Follows 37signals approach - server-rendered HTML with minimal, focused JavaScript
- **No external dependencies**: Pure Stimulus controller, no additional gems required

## Testing

PostHog events will appear in your PostHog dashboard. For development, check the browser console for any errors and verify that `window.posthog` is available.

## Maintenance

- Update your PostHog API key in `app/views/layouts/application.html.erb` if needed
- Run `bin/rails stimulus:manifest:update` if you modify the PostHog controller
- Monitor PostHog usage and adjust tracking as needed for your analytics goals