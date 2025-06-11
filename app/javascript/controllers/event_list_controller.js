import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.linkTargets.forEach((linkTarget) => {
      linkTarget.addEventListener("click", () => {
        fetch(linkTarget.dataset.eventPath, {
          method: "HEAD",
          headers: {
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
          }
        })
      })
    })
  }
}