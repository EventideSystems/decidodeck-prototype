import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drawer"
export default class extends Controller {
  static targets = ["panel", "overlay", "tab", "icon", "content"]

  connect() {
    console.log("🎯 Drawer controller connected!")
    
    // Log what targets are found
    console.log("Available targets:", {
      panel: this.hasPanelTarget ? "✅" : "❌",
      overlay: this.hasOverlayTarget ? "✅" : "❌", 
      tab: this.hasTabTarget ? "✅" : "❌",
      icon: this.hasIconTarget ? "✅" : "❌",
      content: this.hasContentTarget ? "✅" : "❌"
    })
    
    // Make sure drawer starts closed
    if (this.hasPanelTarget) {
      this.panelTarget.classList.add("translate-x-full")
      this.panelTarget.classList.remove("translate-x-0")
    }
  }

  toggle() {
    console.log("🔄 Toggle button clicked!")
    
    if (!this.hasPanelTarget) {
      console.error("❌ No panel target found")
      return
    }
    
    const isOpen = this.panelTarget.classList.contains("translate-x-0")
    console.log("Current state:", isOpen ? "OPEN" : "CLOSED")
    
    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    console.log("📂 Opening drawer...")
    
    // Slide drawer in
    this.panelTarget.classList.remove("translate-x-full")
    this.panelTarget.classList.add("translate-x-0")
    
    // Show overlay
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("opacity-0", "pointer-events-none")
      this.overlayTarget.classList.add("opacity-100", "pointer-events-auto")
    }
    
    // Apply blur to main content
    if (this.hasContentTarget) {
      this.contentTarget.style.filter = "blur(0.5px)"
      this.contentTarget.style.transition = "filter 300ms ease"
    }
    
    console.log("✅ Drawer opened")
  }

  close() {
    console.log("📁 Closing drawer...")
    
    // Slide drawer out
    this.panelTarget.classList.remove("translate-x-0")
    this.panelTarget.classList.add("translate-x-full")
    
    // Hide overlay  
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("opacity-100", "pointer-events-auto")
      this.overlayTarget.classList.add("opacity-0", "pointer-events-none")
    }
    
    // Remove blur from main content
    if (this.hasContentTarget) {
      this.contentTarget.style.filter = "none"
    }
    
    console.log("✅ Drawer closed")
  }
}
