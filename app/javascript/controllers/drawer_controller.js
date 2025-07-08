import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "toggleButton", "openIcon", "closeIcon"]
  
  connect() {
    // Initialize drawer as closed
    this.close()
  }
  
  toggle() {
    if (this.isOpen()) {
      this.close()
    } else {
      this.open()
    }
  }
  
  open() {
    this.panelTarget.classList.remove("translate-x-full")
    this.panelTarget.classList.add("translate-x-0")
    this.openIconTarget.classList.add("hidden")
    this.closeIconTarget.classList.remove("hidden")
  }
  
  close() {
    this.panelTarget.classList.add("translate-x-full")
    this.panelTarget.classList.remove("translate-x-0")
    this.openIconTarget.classList.remove("hidden")
    this.closeIconTarget.classList.add("hidden")
  }
  
  isOpen() {
    return this.panelTarget.classList.contains("translate-x-0")
  }
}
