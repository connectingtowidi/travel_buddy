import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2';
import flatpickr from "flatpickr"; // You need to import this to use new flatpickr()
// Connects to data-controller="regenerate-itinerary"
export default class extends Controller {

  static targets = [ "interest", "startDate", "endDate", "paxInput", "paxDropdown"];
  
  connect() {
    console.log("RegenerateItineraryController is connected!");

    flatpickr(this.startDateTarget)
    flatpickr(this.endDateTarget)
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
    const pax = this.paxDropdownTarget.value;
    const customPax = this.paxInputTarget.value;
  
      // Check if the user is signed in
      const userSignedIn = this.element.dataset.userSignedIn === "true"; // Check the data attribute
      if (!userSignedIn) {
        console.log("User not signed in");
        // If not signed in, redirect to login
        window.location.href = "/login"; // Adjust URL as needed
        return;
      }

      if (!startDate || !endDate || !interest || !pax) {
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

      // If "10+" was selected, ensure the custom pax field is filled
      if (pax === '10+' && !customPax) {
        Swal.fire({
          title: 'Error!',
          text: 'Please enter a custom number of pax.',
          icon: 'error',
          confirmButtonText: 'OK'
        });
        return;
      }


      // Submit the form after validation passes
      this.element.submit();  // This submits the form

     }
}
