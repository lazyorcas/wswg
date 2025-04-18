import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.linkTargets.forEach(link => {
      link.addEventListener("click", () => {
        this.linkTargets.forEach(otherLink => {
          otherLink.classList.remove("tab-button--active")
          otherLink.classList.add("tab-button--inactive")
        })
        link.classList.add("tab-button--active")
        link.classList.remove("tab-button--inactive")
      })
    })
  }
}