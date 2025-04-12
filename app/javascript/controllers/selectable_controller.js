import { Controller } from "@hotwired/stimulus"

// Controls the selection of learning items
export default class extends Controller {
  static targets = ["checkbox", "indicator"]

  connect() {
    // Initialize state based on checkbox
    this.updateSelectionState()
  }

  toggle() {
    // Toggle the checkbox state
    this.checkboxTarget.checked = !this.checkboxTarget.checked
    this.updateSelectionState()
  }

  updateSelectionState() {
    // Update the visual state based on checkbox
    if (this.checkboxTarget.checked) {
      this.element.classList.add("selected")
    } else {
      this.element.classList.remove("selected")
    }
  }
}