// app/javascript/controllers/dietary_preferences_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Optional: Initialization code if needed
  }
  
  change(event) {
    const select = this.element
    const selectedOptions = Array.from(select.selectedOptions).map(option => option.value)
    
    if (selectedOptions.includes('No Preference')) {
      // If "No Preference" is selected, deselect all other options
      Array.from(select.options).forEach(option => {
        if (option.value !== 'No Preference') {
          option.selected = false
        }
      })
    } else if (selectedOptions.length > 0) {
      // If any other option is selected, deselect "No Preference"
      Array.from(select.options).forEach(option => {
        if (option.value === 'No Preference') {
          option.selected = false
        }
      })
    }
  }
}