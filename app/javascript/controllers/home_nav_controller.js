import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.linkTargets.forEach(link => {
      link.addEventListener("click", () => {
        this.linkTargets.forEach(otherLink => {
          otherLink.classList.remove("map-tab-button--active")
          otherLink.classList.add("map-tab-button--inactive")

          otherLink.querySelector("i").classList.remove("ph-fill")
          otherLink.querySelector("i").classList.add("ph")
        })
        link.classList.add("map-tab-button--active")
        link.classList.remove("map-tab-button--inactive")

        link.querySelector("i").classList.remove("ph")
        link.querySelector("i").classList.add("ph-fill")
      })
    })
  }
}