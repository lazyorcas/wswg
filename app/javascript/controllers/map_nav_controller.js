import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  linkTargetConnected(target) {
    target.addEventListener("click", () => {
      this.linkTargets.forEach(otherLink => {
        otherLink.classList.remove("map-tab-button--active")
        otherLink.classList.add("map-tab-button--inactive")
        otherLink.querySelector("i").classList.remove("ph-fill")
        otherLink.querySelector("i").classList.add("ph")
      })
      target.classList.add("map-tab-button--active")
      target.classList.remove("map-tab-button--inactive")

      target.querySelector("i").classList.remove("ph")
      target.querySelector("i").classList.add("ph-fill")
    })
  }
}