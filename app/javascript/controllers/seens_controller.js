import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  createSeen({ params: { eventId, seenPath } }) {
    const formData = new FormData()
    formData.append("seen[event_id]", eventId)

    fetch(seenPath, {
      method: "PUT",
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: formData
    })
  }
}