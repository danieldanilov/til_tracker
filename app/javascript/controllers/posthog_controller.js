import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="posthog"
export default class extends Controller {
  static targets = ["email"]
  static values = {
    formId: String,
    event: { type: String, default: "form_submitted" }
  }

  connect() {
    // Reason: Ensure PostHog is available before attempting to use it
    if (!window.posthog) {
      console.warn("PostHog not initialized")
      return
    }
  }

  submit(event) {
    if (!window.posthog) return

    // Get form data for analytics
    const formData = new FormData(this.element)
    const properties = {
      form_id: this.formIdValue || this.element.id || "unknown_form"
    }

    // Add form field data to properties (excluding sensitive fields)
    for (let [key, value] of formData.entries()) {
      // Skip authenticity token and other Rails internal fields
      if (!key.startsWith("authenticity_token") && !key.startsWith("_")) {
        properties[key] = value
      }
    }

    // Identify user if email is present
    if (this.hasEmailTarget) {
      const email = this.emailTarget.value.trim()
      if (email) {
        properties.email = email
        this.identifyUser(email)
      }
    }

    // Capture the form submission event
    window.posthog.capture(this.eventValue, properties)
  }

  identifyUser(email) {
    const domain = email.split('@')[1]?.toLowerCase()
    const groupDomains = {
      'automattic.com': 'automattic',
      'posthog.com': 'posthog'
      // Add more company domains as needed
    }

    const company = groupDomains[domain] || null

    window.posthog.identify(email, {
      email: email,
      company: company
    })

    // Group by company if applicable
    if (company) {
      window.posthog.group('company', company, {
        email_domain: domain,
        label: company
      })
    }
  }

  // Track custom events
  track(event) {
    if (!window.posthog) return

    const eventName = event.params.event || "custom_event"
    const properties = event.params || {}

    window.posthog.capture(eventName, properties)
  }
}