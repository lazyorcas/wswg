import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "message" ]

  shownDuration = 10000

  messageTargetConnected(target) {
    // add a delay to remove the flash message
    setTimeout(() => {
      target.remove()
    }, this.shownDuration)
  }
}