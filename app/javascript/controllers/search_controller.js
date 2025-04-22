import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["searchInput", "results"];

  connect() {
    this.searchInputTarget.addEventListener("input", this.search.bind(this));
  }
  
  clear() {
    this.resultsTarget.innerHTML = "";
  }

  search(e) {
    if (e.target.value === "") {
      this.clear();
    }
  }
}
