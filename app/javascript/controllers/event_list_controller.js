import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  linkTargetConnected(target) {
    target.addEventListener("click", () => {
      fetch(target.dataset.eventPath, {
        method: "HEAD",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        }
      })
    })
  }
}