import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="task-list"
export default class extends Controller {
  static targets = ["checkbox"]
  static values = { 
    artifactId: String,
    contentType: String,
    workspaceId: String
  }

  connect() {
    console.log("Task list controller connected", {
      artifactId: this.artifactIdValue,
      workspaceId: this.workspaceIdValue,
      contentType: this.contentTypeValue
    })
  }

  toggle(event) {
    console.log("Toggle called", event.target)
    const checkbox = event.target
    const listItem = checkbox.closest("li.task-list-item")
    
    if (!listItem) {
      console.log("No list item found")
      return
    }
    
    // Find the position of this task item in the list
    const taskItems = this.element.querySelectorAll("li.task-list-item")
    const taskIndex = Array.from(taskItems).indexOf(listItem)
    
    if (taskIndex === -1) {
      console.log("Task index not found")
      return
    }
    
    // Determine if we're checking or unchecking
    const isChecked = checkbox.checked
    
    console.log("Updating task", { taskIndex, isChecked })
    
    // Send the update to the server
    this.updateTaskList(taskIndex, isChecked)
  }

  async updateTaskList(taskIndex, isChecked) {
    const url = `/workspaces/${this.workspaceIdValue}/artifacts/${this.artifactIdValue}/toggle_task`
    
    console.log("Making request to", url)
    const response = await fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
      },
      body: JSON.stringify({
        content_type: this.contentTypeValue,
        task_index: taskIndex,
        checked: isChecked
      })
    })
    
    if (!response.ok) {
      // Revert the checkbox state if the update failed
      const checkbox = this.element.querySelectorAll("li.task-list-item input[type='checkbox']")[taskIndex]
      if (checkbox) {
        checkbox.checked = !isChecked
      }
      console.error("Failed to update task list", response.status, response.statusText)
    } else {
      console.log("Task list updated successfully")
    }
  }
}
