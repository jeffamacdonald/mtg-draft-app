import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "offererPick", "offereePick"]

  updateSubmitButton() {
    const offererPicksSelected = this.offererPickTargets.some(input => input.checked)
    const offereePicksSelected = this.offereePickTargets.some(input => input.checked)
    
    this.submitButtonTarget.disabled = !(offererPicksSelected && offereePicksSelected)
  }
}