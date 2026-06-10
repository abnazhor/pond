// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.getAttribute("url"))
}

Turbo.StreamActions.close_dialog = function () {
  const modal = document.getElementById(this.getAttribute("target"))
  if (!modal) return

  modal.dispatchEvent(
    new CustomEvent("dialog:close", {
      bubbles: true
    })
  )
}
