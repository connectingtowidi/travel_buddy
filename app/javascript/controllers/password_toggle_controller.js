import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-toggle"
export default class extends Controller {
  static targets = ["input", "toggle"]

  toggle() {

  //     var passwordField = document.getElementById("password");
  //     if (passwordField.type === "password") {
  //         passwordField.type = "text";
  //     } else {
  //         passwordField.type = "password";
  //     }
  // }

  console.log("toggle")
  
    const type = this.inputTarget.type === "password" ? "text" : "password"
    this.inputTarget.type = type
   
  
  }
}
