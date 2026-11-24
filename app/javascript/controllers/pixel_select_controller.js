import { Controller } from "@hotwired/stimulus";

// Replaces a native <select> with a button + listbox so the open list can use the theme font
// (browsers draw native select lists with the system font). The <select> stays in the DOM
// as the source of truth, so forms and `change` actions keep working.
export default class extends Controller {
  connect() {
    // Turbo's page cache can restore a snapshot that already contains our wrapper.
    this.element.previousElementSibling?.matches(".pixel-select") && this.element.previousElementSibling.remove();

    this.wrapper = document.createElement("div");
    this.wrapper.className = "pixel-select";

    this.button = document.createElement("button");
    this.button.type = "button";
    this.button.className = "pixel-select__button";
    this.button.setAttribute("aria-haspopup", "listbox");
    this.button.setAttribute("aria-expanded", "false");

    this.list = document.createElement("ul");
    this.list.className = "pixel-select__list";
    this.list.setAttribute("role", "listbox");
    this.list.hidden = true;

    Array.from(this.element.options).forEach((option, index) => {
      const item = document.createElement("li");
      item.setAttribute("role", "option");
      item.dataset.index = index;
      item.textContent = option.textContent;
      this.list.append(item);
    });

    this.wrapper.append(this.button, this.list);
    this.element.before(this.wrapper);
    this.element.classList.add("pixel-select__native");

    this.onButtonClick = () => (this.list.hidden ? this.open() : this.close());
    this.onKeydown = this.keydown.bind(this);
    this.onItemClick = (event) => {
      const item = event.target.closest("li");
      if (item) this.choose(Number(item.dataset.index));
    };
    this.onOutsideClick = (event) => {
      if (!this.wrapper.contains(event.target)) this.close();
    };

    this.button.addEventListener("click", this.onButtonClick);
    this.wrapper.addEventListener("keydown", this.onKeydown);
    this.list.addEventListener("click", this.onItemClick);
    document.addEventListener("click", this.onOutsideClick);

    this.sync();
  }

  disconnect() {
    document.removeEventListener("click", this.onOutsideClick);
    this.wrapper?.remove();
    this.element.classList.remove("pixel-select__native");
  }

  sync() {
    const selected = this.element.selectedIndex;
    this.button.textContent = this.element.options[selected]?.textContent ?? "";
    Array.from(this.list.children).forEach((item, index) => {
      item.setAttribute("aria-selected", index === selected ? "true" : "false");
    });
  }

  open() {
    this.list.hidden = false;
    this.button.setAttribute("aria-expanded", "true");
    this.highlight(this.element.selectedIndex);
  }

  close() {
    this.list.hidden = true;
    this.button.setAttribute("aria-expanded", "false");
  }

  highlight(index) {
    this.active = Math.max(0, Math.min(index, this.list.children.length - 1));
    Array.from(this.list.children).forEach((item, i) => item.classList.toggle("is-active", i === this.active));
    this.list.children[this.active]?.scrollIntoView({ block: "nearest" });
  }

  choose(index) {
    if (index !== this.element.selectedIndex) {
      this.element.selectedIndex = index;
      this.element.dispatchEvent(new Event("change", { bubbles: true }));
    }
    this.sync();
    this.close();
    this.button.focus();
  }

  keydown(event) {
    const isOpen = !this.list.hidden;
    switch (event.key) {
      case "ArrowDown":
      case "ArrowUp":
        event.preventDefault();
        if (!isOpen) return this.open();
        this.highlight(this.active + (event.key === "ArrowDown" ? 1 : -1));
        break;
      case "Enter":
      case " ":
        if (isOpen) {
          event.preventDefault();
          this.choose(this.active);
        }
        break;
      case "Escape":
      case "Tab":
        if (isOpen) this.close();
        break;
    }
  }
}
