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

  // Function to hide the loading overlay
  hideLoadingOverlay() {
    this.loadingOverlayTarget.style.display = "none";
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
    const dietaryPreferences = this.dietaryPreferencesTarget ? this.dietaryPreferencesTarget.value : "No Preference"; // Assuming dietary preferences have a target

   
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
   
      // Submit the form first (trigger the form submission)
      this.formTarget.submit();

      // After form submission, show the loading overlay and initial message
      this.showLoadingOverlay(`Generating your perfect itinerary for ${interest}...`);

      // Sequence of messages to engage the user
    setTimeout(() => {
      this.showLoadingOverlay(`Gathering the best options for you in ${interest} from ${startDate} to ${endDate} for ${pax} people with dietary preferences: ${dietaryPreferences}...`);
    }, 2000); // After 3 seconds, change the text

    setTimeout(() => {
      this.showLoadingOverlay(`Optimizing your trip from ${startDate} to ${endDate} for ${pax} people with dietary preferences: ${dietaryPreferences}...`);
    }, 4000); // After another 3 seconds, update the message

    setTimeout(() => {
      this.showLoadingOverlay(`Almost there, finalizing your itinerary for ${interest}...`);
    }, 9000); // After another 3 seconds, change the message

    // Submit the form after the final message
    setTimeout(() => {
      this.formTarget.submit(); // Trigger the form submission
      this.hideLoadingOverlay(); // Hide the loading overlay once done
    }, 12000); // Final step after 12 seconds (simulate the end of the process)

    } else {
      console.error("Form target is not found.");
      // Hide loading overlay if form submission fails
      this.loadingOverlayTarget.style.display = "none";
    }
  }
}
