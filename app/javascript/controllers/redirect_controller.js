import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  connect() {
    console.log("redirect");
  }

  redirectToLogin(event) {
    event.preventDefault();
    window.location.href = "/login"; // Adjust the path if needed for your app.
  }
}
