import { Controller } from "@hotwired/stimulus"

// !!!! THIS CONTROLLER DOES NOT APPEAR TO BE USED IN THE CURRENT CODEBASE
// It seems to be a replacement for the drawer_controller.js, but is not linked in any HTML files.
// If you are looking for the drawer functionality, please refer to drawer_controller.js instead.
// Connects to data-controller="drawer-toggle"
export default class extends Controller {
  static targets = ["drawer", "overlay", "icon"]

  connect() {
    // Ensure drawer starts in closed position
    this.close()
    // Add escape key listener
    document.addEventListener('keydown', this.handleKeydown.bind(this))
  }

  disconnect() {
    // Clean up event listener
    document.removeEventListener('keydown', this.handleKeydown.bind(this))
  }

  toggle() {
    if (this.isOpen()) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    console.log('Opening drawer') // Debug log
    
    // Show overlay
    this.overlayTarget.classList.remove("opacity-0", "pointer-events-none")
    this.overlayTarget.classList.add("opacity-100", "pointer-events-auto")
    
    // Slide drawer in from right
    this.drawerTarget.classList.remove("translate-x-full")
    this.drawerTarget.classList.add("translate-x-0")
    
    // Rotate arrow icon
    if (this.hasIconTarget) {
      this.iconTarget.classList.remove("rotate-0")
      this.iconTarget.classList.add("rotate-180")
    }
    
    // Prevent body scroll
    document.body.style.overflow = 'hidden'
  }

  close() {
    console.log('Closing drawer') // Debug log
    
    // Hide overlay
    this.overlayTarget.classList.remove("opacity-100", "pointer-events-auto")
    this.overlayTarget.classList.add("opacity-0", "pointer-events-none")
    
    // Slide drawer out to right
    this.drawerTarget.classList.remove("translate-x-0")
    this.drawerTarget.classList.add("translate-x-full")
    
    // Reset arrow icon
    if (this.hasIconTarget) {
      this.iconTarget.classList.remove("rotate-180")
      this.iconTarget.classList.add("rotate-0")
    }
    
    // Restore body scroll
    document.body.style.overflow = ''
  }

  isOpen() {
    return this.drawerTarget.classList.contains("translate-x-0")
  }

  // Handle escape key
  handleKeydown(event) {
    if (event.key === "Escape" && this.isOpen()) {
      this.close()
    }
  }
}
