import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {}

  close(event) {
    event.preventDefault();\
    const modal = document.getElementById("modal");
    modal.innerHTML = "";
    modal.removeAttribute("src");
    modal.removeAttribute("complete");
  }
}
