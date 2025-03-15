import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]
  
  connect() {
    this.timeout = null
    this.duration = 300 // milliseconds to wait before submitting
    this.element.addEventListener("input", this.debounce.bind(this))
  }
  
  debounce(event) {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.form.requestSubmit()
    }, this.duration)
  }
}