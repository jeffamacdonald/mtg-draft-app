import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"
import * as Turbo from "@hotwired/turbo"

export default class extends Controller {
  static values = { draftId: String }

  connect() {
    this.channel = consumer.subscriptions.create(
      { channel: "DraftChannel", id: this.draftIdValue },
      {
        received: this.received.bind(this)
      }
    )
  }

  disconnect() {
    if (this.channel) {
      consumer.subscriptions.remove(this.channel)
    }
  }

  received(data) {
    Turbo.visit(location.toString());
  }
}