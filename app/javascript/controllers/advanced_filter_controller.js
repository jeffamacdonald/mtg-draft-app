import { Controller } from "@hotwired/stimulus";
import { Modal } from "bootstrap";

// Builds a search query from the Advanced Filters modal's fields and applies it.
export default class extends Controller {
  static targets = ["field", "is"];

  apply() {
    const terms = this.fieldTargets.map((field) => this.termFor(field)).filter(Boolean);
    terms.push(...this.isTargets.filter((box) => box.checked).map((box) => `is:${box.value}`));

    const form = this.element.closest("form");
    form.querySelector("input[type=text][name$='[query]']").value = terms.join(" ");
    Modal.getOrCreateInstance(this.element).hide();
    this.application.getControllerForElementAndIdentifier(form, "filterable").apply();
  }

  reset() {
    this.fieldTargets.forEach((field) => (field.querySelector("[data-role=value]").value = ""));
    this.isTargets.forEach((box) => (box.checked = false));
  }

  termFor(field) {
    const value = field.querySelector("[data-role=value]").value.trim();
    if (!value) return null;

    const op = field.querySelector("[data-role=op]")?.value || ":";
    return `${field.dataset.key}${op}${/[\s"']/.test(value) ? `"${value.replace(/"/g, "")}"` : value}`;
  }
}
