import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="update-booking-status"
export default class extends Controller {

  static targets = ["form"]

  connect() {
    console.log("Hello from update booking status controller")
  }

  fire(event) {
    event.preventDefault()
    console.log("Submit button clicked")
    // console.log(this.confirmButtonTarget)
    console.log(event.target)
    console.log(event.target.action)

    // console.log(event.target.form)
    // http://127.0.0.1:3000/itineraries/4/update_ticket_booking_status
    fetch(event.target.action, {
      method: "POST",
      headers: {
        "Accept": "application/json"
        // "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: new FormData(this.formTarget)
    })
    .then(response => {
      if (response.ok) {
        window.location.href = this.formTarget.dataset.successUrl
      }
    })
    // .then(response => response.json())
    // .then(data => {
    //   console.log("Updating booking status")
    // })
    .catch(error => {
      console.error("Error:", error)
    })
  }
}
