import { Controller } from "@hotwired/stimulus";
import debounce from "lodash/debounce";
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["search"];
  static values = {
    debounceMs: { type: Number, default: 200 },
  };

  initialize() {
    this.search = debounce(this.apply, this.debounceMsValue);
  }

  connect() {
    this.element.addEventListener("ajax:success", (e) => {
      const [data, status, xhr] = e.detail;
      window.history.replaceState(null, null, xhr.responseURL);
    });
    if (this.hasSearchTarget) {
      var value = this.searchTarget.value;
      this.searchTarget.focus();
      this.searchTarget.value = "";
      this.searchTarget.value = value;
    }
  }

  apply() {
    if (this.element.dataset["remote"] == "true") {
      Rails.fire(this.element, "submit");
    } else {
      this.element.submit();
    }
  }
}
