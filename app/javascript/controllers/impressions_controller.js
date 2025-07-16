import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["event"]
  static values = {
    impressionPath: String
  }

  connect() {
    this.intersectionObserver = new IntersectionObserver(
      this.intersectionObserverCallback.bind(this), 
      {
        rootMargin: "0px 0px 0px 0px",
        threshold: 1
      }
    )

    this.eventTargets.forEach(this.observe.bind(this))
  }

  disconnect() {
    this.intersectionObserver.disconnect()
  }

  eventTargetConnected(eventTarget) {
    this.observe(eventTarget)
  }

  eventTargetDisconnected(eventTarget) {
    this.unobserve(eventTarget)
  }

  intersectionObserverCallback(entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        this.entryIntersected(entry)
      }
    })
  }

  entryIntersected(entry) {
    this.createImpression(entry.target.dataset.eventId)
    this.unobserve(entry.target)
  }

  observe(entry) {
    this.intersectionObserver?.observe(entry)
  }

  unobserve(entry) {
    this.intersectionObserver?.unobserve(entry)
  }

  createImpression(eventId) {
    const formData = new FormData()
    formData.append("impression[event_id]", eventId)

    fetch(this.impressionPathValue, {
      method: "PUT",
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: formData
    })
  }
}