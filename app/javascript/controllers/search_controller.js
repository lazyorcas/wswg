import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["searchInput", "submitButton", "results", "status"];
  
  clear() {
    this.resultsTarget.innerHTML = "";
  }

  blur() {
    this.searchInputTarget.blur();
  }

  input(e) {
    if (e.target.value === "") {
      this.clear();
    }
  }

  enable() {
    this.submitButtonTarget.classList.remove("button--disabled");
    this.submitButtonTarget.classList.add("button--primary");
  }

  disable() {
    this.submitButtonTarget.classList.remove("button--primary");
    this.submitButtonTarget.classList.add("button--disabled");
  }

  showStatus() {
    this.statusTarget.classList.remove("hidden");
    this.statusTarget.classList.add("flex");
  }

  hideStatus() {
    this.statusTarget.classList.remove("flex");
    this.statusTarget.classList.add("hidden");
  }
}
