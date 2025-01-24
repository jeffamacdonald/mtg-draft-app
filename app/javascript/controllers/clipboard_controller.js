import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["button"]
  static values = {
    cardpool: String
  }

  copy() {
    navigator.clipboard.writeText(this.cardpoolValue)
      .then(() => {
        // === UPDATE BUTTON TEXT TO COPIED ===
        this.buttonTarget.textContent = 'Copied';

        // === RESET THE BUTTON TEXT AFTER 2 SECONDS ===
        setTimeout(() => {
          this.buttonTarget.textContent = 'Copy';
        }, 2000);
      })
      .catch((error) => {
        console.error('Failed to copy text to clipboard:', error);
      });
  }
}
