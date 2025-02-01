import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this));
  }

  handleSubmitEnd(event) {
    if (event.detail.success) {
      this.close(event);
    }
  }

  close(event) {
    event.preventDefault();
    const modal = document.getElementById("modal");
    modal.innerHTML = "";
    modal.removeAttribute("src");
    modal.removeAttribute("complete");
  }
}
