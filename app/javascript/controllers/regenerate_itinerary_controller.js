import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2';
// Connects to data-controller="regenerate-itinerary"
export default class extends Controller {

  static targets = [ "interest", "startDate", "endDate", "paxInput", "paxDropdown"];
  
  connect() {
    console.log("RegenerateItineraryController is connected!");
  }


  togglePaxInput() {
    const selectedValue = this.paxDropdownTarget.value;
    if (selectedValue === "10+" || selectedValue === "custom") {
      this.paxInputTarget.style.display = "block"; // Show the input field
    } else {
      this.paxInputTarget.style.display = "none"; // Hide the input field
    }
  }

  regenerate(event) {
    event.preventDefault();
    console.log("Regenerate button clicked!");

    const startDate = this.startDateTarget.value;
    const endDate = this.endDateTarget.value;
    const interest = this.interestTarget.value;
    const numberOfPax = this.paxDropdownTarget.value;
  
      // Check if the user is signed in
      const userSignedIn = this.element.dataset.userSignedIn === "true"; // Check the data attribute
      if (!userSignedIn) {
        console.log("User not signed in");
        // If not signed in, redirect to login
        window.location.href = "/login"; // Adjust URL as needed
        return;
      }
    if (!startDate || !endDate || !interest || !numberOfPax) {
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


    // Call Generate Itinerary service 
    // fetch(this.formTarget.action, {
    //   method: "POST", // Could be dynamic with Stimulus values
    //   headers: { "Accept": "application/json" },
    //   body: new FormData(this.formTarget)
    // })
    //   .then(response => response.json())
    //   .then((data) => {
    //     console.log(data)
    //   })

     }
}
