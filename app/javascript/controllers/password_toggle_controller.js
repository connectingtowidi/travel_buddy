import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["password", "toggleIcon"];

  connect() {
    console.log("password");
  }

  toggle() {
    const passwordField = this.passwordTarget;
    const isPassword = passwordField.type === "password";

    if (isPassword) {
      this.passwordTarget.type = "text"
      this.toggleIconTarget.classList.remove("fa-eye-slash")
      this.toggleIconTarget.classList.add("fa-eye")
    } else
    {
        this.passwordTarget.type = "password"
      this.toggleIconTarget.classList.add("fa-eye-slash")
      this.toggleIconTarget.classList.remove("fa-eye")

    }
  }
}
