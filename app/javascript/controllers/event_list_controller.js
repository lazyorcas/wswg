import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  linkTargetConnected(target) {
    target.addEventListener("click", () => {
      try {
        fetch(target.dataset.eventPath, {
          method: "HEAD",
          headers: {
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
          }
        })
      } catch (error) {
        console.error("Error fetching event:", error);
      }
    })
  }
}