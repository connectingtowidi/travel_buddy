import { Application } from "@hotwired/stimulus"
import PasswordToggleController from "./controllers/password_toggle_controller"
import RedirectController from "./controllers/redirect_controller"

const application = Application.start()
application.register("password_toggle", PasswordToggleController)
application.register("redirect", RedirectController)
// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
