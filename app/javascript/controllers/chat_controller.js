import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "submit"];

  clear() {
    this.submitTarget.reset();
  }

  connect() {
    this.observeMessages();
    this.scrollToBottom();
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }

  observeMessages() {    
    if (this.hasMessagesTarget) {
      const draftMessagesElement = this.messagesTarget.querySelector("#draft_chat_messages");

      if (draftMessagesElement) {
        const observer = new MutationObserver(() => {
          this.scrollToBottom();
        });

        observer.observe(draftMessagesElement, {
          childList: true, // Detect when children are added/removed
          subtree: false,  // Observe nested nodes
        });

        // Store the observer so it can be disconnected if needed
        this.observer = observer;
      } else {
        console.error("#draft_chat_messages not found!");
      }
    } else {
      console.error("Messages target not found!");
    }
  }

  disconnect() {
    // Disconnect observer to avoid memory leaks
    if (this.observer) {
      this.observer.disconnect();
    }
  }
}

