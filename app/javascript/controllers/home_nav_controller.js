import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.linkTargets.forEach(link => {
      link.addEventListener("click", () => {
        this.linkTargets.forEach(otherLink => {
          otherLink.classList.remove("home-tab-button--active")
          otherLink.classList.add("home-tab-button--inactive")
        })
        link.classList.add("home-tab-button--active")
        link.classList.remove("home-tab-button--inactive")
      })
    })
  }
}