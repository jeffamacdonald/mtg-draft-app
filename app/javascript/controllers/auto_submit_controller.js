import { Controller } from "@hotwired/stimulus";

// Submits the form when a field inside it changes (e.g. `data-action="change->auto-submit#submit"`).
export default class extends Controller {
  submit() {
    this.element.requestSubmit();
  }
}
