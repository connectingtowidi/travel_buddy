// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"


import PasswordToggleController from "../controllers/password_toggle_controller.js"
Stimulus.register("password_toggle", PasswordToggleController)


import RedirectController from "../controllers/redirect_controller.js"
Stimulus.register("redirect", RedirectController)