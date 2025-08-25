import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    content: String
  }

  copy(event) {
    event.preventDefault()
    navigator.clipboard.writeText(this.contentValue)
  }
}