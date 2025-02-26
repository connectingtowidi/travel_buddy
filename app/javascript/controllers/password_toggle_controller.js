import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["password", "toggleIcon"];

  connect() {
    console.log("password");
  }

  toggle() {
    const passwordField = this.passwordTarget;
    const isPassword = passwordField.type === "password";

    // Toggle input type
    passwordField.type = isPassword ? "text" : "password";

    // Change eye icon (optional)
    this.toggleIconTarget.textContent = isPassword ? "🙈" : "👁";
  }
}
