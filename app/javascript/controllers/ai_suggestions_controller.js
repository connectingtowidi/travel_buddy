import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "lockedAttractions", "loadingOverlay", "aiPrompt"]

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

  // Function to show the loading overlay and change the message
  showLoadingOverlay(message) {
    // Show the loading overlay
    this.loadingOverlayTarget.style.display = "flex";

    // Update the loading message text
    const loadingMessage = document.getElementById("loading-message");

    if (loadingMessage) {
  
      // Delay setting the text until after DOM has been updated
      setTimeout(() => {
        loadingMessage.innerText = message;
      }, 0); // Set message in the next event loop
    }

   
  }

  submitForm(event) {
    event.preventDefault()
    if (!this.hasFormTarget) return

    const promptValue = this.aiPromptTarget.value
    console.log("AI Prompt:", promptValue)
    // Update the hidden field with locked attractions
    this.updateLockedAttractions()

    try {
      // Show the loading overlay BEFORE submitting the form
      this.loadingOverlayTarget.style.display = "flex"
      console.log("Set display to flex")
      
      // Update message
      const loadingMessage = document.getElementById("loading-message")
      if (loadingMessage) {
        loadingMessage.textContent = `Generating an update to your perfect itinerary based on your request: ${promptValue}`
      }
      
      // Then submit the form
      this.formTarget.submit()
      
    } catch (error) {
      console.error("Error showing loading overlay:", error)
      // If there's an error showing the overlay, still submit the form
      this.formTarget.submit()
    }
  } 
}