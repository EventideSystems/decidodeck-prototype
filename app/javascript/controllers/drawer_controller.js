import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "closedToggle"]
  
  connect() {
    // Initialize drawer as partially closed (showing part of the panel)
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
    this.panelTarget.classList.remove("translate-x-64")
    this.panelTarget.classList.add("translate-x-0")
    this.closedToggleTarget.classList.add("hidden")
  }
  
  close() {
    this.panelTarget.classList.add("translate-x-64")
    this.panelTarget.classList.remove("translate-x-0")
    this.closedToggleTarget.classList.remove("hidden")
  }
  
  isOpen() {
    return this.panelTarget.classList.contains("translate-x-0")
  }
}
