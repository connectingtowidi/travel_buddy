import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "lockedAttractions"]
  static values = {
    locked: { type: Array, default: [] }
  }

  connect() {
    this.updateLockedAttractions()
  }

  toggleLock(event) {
    event.preventDefault()
    const button = event.currentTarget
    const attractionId = button.dataset.attractionId
    const card = button.closest('.itinerary-card')
    
    if (this.lockedValue.includes(attractionId)) {
      // If already locked, unlock it
      this.lockedValue = this.lockedValue.filter(id => id !== attractionId)
      button.innerHTML = '<i class="fas fa-unlock" style="color: #6c757d;"></i>'
      button.title = 'Lock this attraction'
      card.style.borderLeft = '4px solid rgb(121, 160, 135)' // Default color
    } else {
      // If unlocked, lock it
      this.lockedValue = [...this.lockedValue, attractionId]
      button.innerHTML = '<i class="fas fa-lock" style="color: #28a745;"></i>'
      button.title = 'Unlock this attraction'
      card.style.borderLeft = '4px solid #28a745' // Green color for locked
    }
    
    this.updateLockedAttractions()
  }

  updateLockedAttractions() {
    if (this.hasLockedAttractionsTarget) {
      this.lockedAttractionsTarget.value = this.lockedValue.join(',')
    }
  }

  submitForm(event) {
    event.preventDefault()
    if (!this.hasFormTarget) return

    // Update the hidden field with locked attractions
    this.updateLockedAttractions()

    // Submit the form
    this.formTarget.submit()
  }
} 