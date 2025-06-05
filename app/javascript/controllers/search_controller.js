import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["searchInput", "results", "status"];
  
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

  showStatus() {
    this.statusTarget.classList.remove("hidden");
    this.statusTarget.classList.add("flex");
  }

  hideStatus() {
    this.statusTarget.classList.remove("flex");
    this.statusTarget.classList.add("hidden");
  }
}
