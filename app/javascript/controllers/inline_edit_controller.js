import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text", "form"];
  // static values = { url: String };

  connect() {
    this.editing = false;
    this.boundOutsideClick = this.outsideClick.bind(this);
  }

  toggleEdit() {
    if (this.editing && event.target.closest("form")) {
      return; // Don't toggle if clicking inside the form
    }

    if (event.target.tagName === "A") {
      return; // Don't toggle if clicking a link
    }

    this.editing = !this.editing;
    this.textTarget.style.display = this.editing ? "none" : "block";
    this.formTarget.style.display = this.editing ? "block" : "none";

    if (this.editing) {
      const input = this.formTarget.querySelector("input");
      input.focus();

      // Move the cursor to the end of the text
      const value = input.value;
      input.value = ""; // Reset value to move cursor
      input.value = value; // Reassign to retain value and move cursor to end

      document.addEventListener("click", this.boundOutsideClick);
    } else {
      document.removeEventListener("click", this.boundOutsideClick);
    }
  }

  outsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.toggleEdit();
    }
  }
}