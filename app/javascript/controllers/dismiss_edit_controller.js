import { Controller } from "@hotwired/stimulus";

// Put on an edit form loaded into a Turbo Frame. Clicking outside the surrounding
// table cell discards the form by reloading the frame with its display version.
export default class extends Controller {
  static values = { url: String };

  connect() {
    this.boundOutsideClick = this.outsideClick.bind(this);
    document.addEventListener("click", this.boundOutsideClick);
  }

  disconnect() {
    document.removeEventListener("click", this.boundOutsideClick);
  }

  outsideClick(event) {
    const boundary = this.element.closest("td") || this.element;
    if (boundary.contains(event.target)) return;

    this.element.closest("turbo-frame").src = this.urlValue;
  }
}
