import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["searchInput", "results"];
  
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
}
