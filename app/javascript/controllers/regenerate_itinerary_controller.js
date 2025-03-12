import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2';
// Connects to data-controller="regenerate-itinerary"
export default class extends Controller {

  static targets = ["startDate", "endDate"];

  connect() {
    console.log("RegenerateItineraryController is connected!");
  }

  regenerate(event) {
    event.preventDefault();
    console.log("Regenerate button clicked!");

    const startDate = this.startDateTarget.value;
    const endDate = this.endDateTarget.value;
    const interest = document.querySelector("#interest-dropdown-frame select")?.value; // Adjust selector if needed

    
    if (!startDate || !endDate ) {
      Swal.fire({
        title: 'Error!',
        text: 'Please fill in all fields before regenerating the itinerary.',
        icon: 'error',
        confirmButtonText: 'OK'
      });
      return;
    }
  
    if (endDate < startDate) {
      Swal.fire({
        title: 'Error!',
        text: 'End date must be after start date.',
        icon: 'error',
        confirmButtonText: 'OK'
      });
      return;
    }
  }
}
