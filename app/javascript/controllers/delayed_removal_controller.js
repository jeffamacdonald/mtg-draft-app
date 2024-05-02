import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { delay: { type: Number, default: 3000 } };

  connect() {
    setTimeout(() => this.element.remove(), this.delayValue);
  }
}
