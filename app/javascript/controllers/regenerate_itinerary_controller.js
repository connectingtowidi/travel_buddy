import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2';
import flatpickr from "flatpickr"; // You need to import this to use new flatpickr()
// Connects to data-controller="regenerate-itinerary"
export default class extends Controller {

  static targets = [ "interest", "startDate", "endDate", 
    "paxInput", "paxDropdown", 
    "customPaxContainer", "paxContainer", 
    "form", "loadingOverlay"];

  
  connect() {
    console.log("RegenerateItineraryController is connected!");

    this.initializeFlatpickr();
  }

  togglePaxInput() {
    const selectedPax = this.paxDropdownTarget.value;

    if (selectedPax === "10+") {
      this.customPaxContainerTarget.style.display = "block"; // Show custom pax input
      this.paxContainerTarget.style.display = "none"; // Show custom pax input
      this.paxInputTarget.required = true; // Make the custom input required
      this.paxDropdownTarget.required = false;
    } else {
      this.customPaxContainerTarget.style.display = "none"; // Hide custom pax input
      this.paxContainerTarget.style.display = "block"; 
      this.paxInputTarget.required = false; // Make the custom input not required
      this.paxDropdownTarget.required = true;
    }
  }


  showLoadingOverlay() {
    console.log("Form submitted, showing loading overlay")
    this.loadingOverlayTarget.style.display = 'flex'
  }

  initializeFlatpickr() {
    // Common configuration for both date pickers
    const dateConfig = {
      dateFormat: "Y-m-d",
      allowInput: true,
      minDate: "today",
      disableMobile: true // Better experience on mobile
    };
    
    // Initialize start date picker
    const startDatePicker = flatpickr(this.startDateTarget, {
      ...dateConfig,
      onChange: (selectedDates) => {
        // Update end date min date when start date changes
        if (selectedDates[0]) {
          endDatePicker.set('minDate', selectedDates[0]);
        }
      }
    });
    
    // Initialize end date picker with reference to start date
    const endDatePicker = flatpickr(this.endDateTarget, {
      ...dateConfig,
      minDate: this.startDateTarget.value || "today"
    });
    
    // Store references to use in other methods if needed
    this.startDatePicker = startDatePicker;
    this.endDatePicker = endDatePicker;
  }

  regenerate(event) {
    event.preventDefault();
    console.log("Regenerate button clicked!");

    
    const startDate = this.startDateTarget.value;
    const endDate = this.endDateTarget.value;
    const interest = this.interestTarget.value;
    const pax = this.paxInputTarget.value || this.paxDropdownTarget.value;
   
    // Check if the user is signed in
    const userSignedIn = this.element.dataset.userSignedIn === "true";
    if (!userSignedIn) {
      console.log("User not signed in");
      // If not signed in, redirect to login
      window.location.href = "/login"; // Adjust URL for Devise
      return;
    }
    
    if (!startDate || !endDate) {
      Swal.fire({
        title: 'Error!',
        text: 'Please select the start and end date before regenerating the itinerary.',
        icon: 'error',
        confirmButtonText: 'OK'
      });
      return;
    }
    
    if (new Date(endDate) < new Date(startDate)) {
      Swal.fire({
        title: 'Error!',
        text: 'End date must be after start date.',
        icon: 'error',
        confirmButtonText: 'OK'
      });
      return;
    }

    if (this.formTarget) {
      // Show loading overlay right before submitting the form
      this.loadingOverlayTarget.style.display = "flex"; // Ensure the overlay is shown
      
      // Optionally add some delay to ensure the overlay appears before form submission
      setTimeout(() => {
        this.formTarget.submit(); // Trigger the form submission
      }, 100); // Small delay before submitting
    } else {
      console.error("Form target is not found.");
      // Hide loading overlay if form submission fails
      this.loadingOverlayTarget.style.display = "none";
    }
  }
}
