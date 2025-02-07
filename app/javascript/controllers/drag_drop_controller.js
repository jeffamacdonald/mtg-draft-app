import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { updateUrl: String }

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,  // Smooth animation
      ghostClass: "sortable-ghost",  // Class for the dragged item
      onEnd: this.updateOrder.bind(this),
    })
  }

  async updateOrder(event) {
    const queuedPickElements = this.element.querySelectorAll("[data-queued-pick-id]");
    const queuedPickIds = Array.from(queuedPickElements).map((element) => element.dataset.queuedPickId);

    const prevFirstBorderElement = document.querySelector(".border-warning")
    const firstBorderElement = document.getElementById(`${queuedPickIds[0]}_border`);
    if (prevFirstBorderElement.id !== firstBorderElement.id) {
      prevFirstBorderElement.classList.remove("border-warning")
      prevFirstBorderElement.classList.remove("border-3")
      prevFirstBorderElement.classList.add("border-dark")
      firstBorderElement.classList.remove("border-dark")
      firstBorderElement.classList.add("border-warning")
      firstBorderElement.classList.add("border-3")
    }

    const response = await fetch(this.updateUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ queued_pick_ids: queuedPickIds }),
    })

    Array.from(queuedPickElements).map((element, index) => {
      const priorityElement = document.getElementById(`${element.dataset.queuedPickId}_priority_number`);
      if (priorityElement) {
        priorityElement.textContent = index + 1;
      }
    });

    if (!response.ok) {
      console.error("Failed to update order")
    }
  }
}
