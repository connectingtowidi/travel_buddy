import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2';
import flatpickr from "flatpickr"; // You need to import this to use new flatpickr()
// Connects to data-controller="regenerate-itinerary"
export default class extends Controller {

  static targets = [ "interest", "startDate", "endDate", 
    "paxInput", "paxDropdown", "dietaryPreferences",
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

  toggle(event) {
    // Get the clicked checkbox
    const clickedCheckbox = event.target;
    const checkboxName = clickedCheckbox.name;
    const allCheckboxes = document.querySelectorAll(`input[name="${checkboxName}"]`);
    
    // If the clicked checkbox is NOT "No Preference" and it was checked
    if (clickedCheckbox.value !== "No Preference" && clickedCheckbox.checked) {
      // Find and uncheck the "No Preference" checkbox
      const noPreferenceCheckbox = Array.from(allCheckboxes).find(checkbox => 
        checkbox.value === "No Preference"
      );
      
      if (noPreferenceCheckbox) {
        noPreferenceCheckbox.checked = false;
      }
    }
    
    // If the clicked checkbox IS "No Preference" and it was checked
    if (clickedCheckbox.value === "No Preference" && clickedCheckbox.checked) {
      // Uncheck all other checkboxes
      allCheckboxes.forEach(checkbox => {
        if (checkbox.value !== "No Preference") {
          checkbox.checked = false;
        }
      });
    }
    
    // Check if any checkbox is checked at all
    const anyChecked = Array.from(allCheckboxes).some(checkbox => checkbox.checked);
    
    // If no checkbox is checked, check "No Preference" by default
    if (!anyChecked) {
      const noPreferenceCheckbox = Array.from(allCheckboxes).find(checkbox => 
        checkbox.value === "No Preference"
      );
      
      if (noPreferenceCheckbox) {
        noPreferenceCheckbox.checked = true;
      }
    }
    
    // Get final checked values for logging
    const checkedValues = Array.from(allCheckboxes)
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);
    
    console.log('Selected dietary preferences:', checkedValues);
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
   
    // Get all checkboxes with the dietary preferences name
  const dietaryCheckboxes = document.querySelectorAll('input[name="itinerary[dietary_preferences][]"]');
  
  // Get all checked dietary preferences
  const checkedDietaryPreferences = Array.from(dietaryCheckboxes)
    .filter(checkbox => checkbox.checked)
    .map(checkbox => checkbox.value);
  
  // Join the values with commas for display
  const dietaryPreferences = checkedDietaryPreferences.length > 0 
    ? checkedDietaryPreferences.join(', ') 
    : "No Preference";

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
      const personText = pax === 1 ? 'person' : 'people';
      this.showLoadingOverlay(`Gathering the best options for you in ${interest} from ${startDate} to ${endDate} for ${pax} ${personText} with dietary preferences: ${dietaryPreferences}...`);
    }, 2000); // After 2 seconds, change the text

    setTimeout(() => {
      const personText = pax === 1 ? 'person' : 'people';
  this.showLoadingOverlay(`Optimizing your trip from ${startDate} to ${endDate} for ${pax} ${personText} with dietary preferences: ${dietaryPreferences}...`);
    }, 12000); // After another 12 seconds, update the message

    setTimeout(() => {
      this.showLoadingOverlay(`Almost there, finalizing your itinerary for ${interest}...`);
    }, 20000); // After another 20 seconds, change the message

    setTimeout(() => {
      this.showLoadingOverlay(`You may modify the curated itinerary to meet your travel needs`);
    }, 30000); // After another 30 seconds, change the message


    setTimeout(() => {
      this.showLoadingOverlay(`Almost there, here is your curated itinerary...`);
    }, 40000); // After another 20 seconds, change the message

    setTimeout(() => {
      this.hideLoadingOverlay(); // Hide the loading overlay once done
    }, 60000); // Final step after 60 seconds (simulate the end of the process)

    } else {
      console.error("Form target is not found.");
      // Hide loading overlay if form submission fails
      this.loadingOverlayTarget.style.display = "none";
    }
  }


}
