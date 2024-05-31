import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="countdown"
export default class extends Controller {
  static targets = ["countdown"];

  connect() {
    this.secondsUntilEnd = this.countdownTarget.dataset.secondsUntilEndValue;

    const now = new Date().getTime();
    this.endTime = new Date(now + this.secondsUntilEnd * 1000);

    this.countdown = setInterval(this.countdown.bind(this), 250);
  }

  countdown() {
    const now = new Date();
    const secondsRemaining = (this.endTime - now) / 1000;

    if (secondsRemaining <= 0) {
      clearInterval(this.countdown);
      this.countdownTarget.innerHTML = "00:00:00";
      this.countdownTarget.classList.add("text-red")
      return;
    }

    const secondsPerDay = 86400;
    const secondsPerHour = 3600;
    const secondsPerMinute = 60;

    const days = Math.floor(secondsRemaining / secondsPerDay);
    const hours = Math.floor(
      (secondsRemaining % secondsPerDay) / secondsPerHour
    ).toLocaleString('en-US', {minimumIntegerDigits: 2, useGrouping:false});
    const minutes = Math.floor(
      (secondsRemaining % secondsPerHour) / secondsPerMinute
    ).toLocaleString('en-US', {minimumIntegerDigits: 2, useGrouping:false});
    const seconds = Math.floor(secondsRemaining % secondsPerMinute).toLocaleString('en-US', {minimumIntegerDigits: 2, useGrouping:false});

    if (days === 1) {
      this.countdownTarget.innerHTML = `1 day ${hours}:${minutes}:${seconds}`;
    } else if (days > 1) {
      this.countdownTarget.innerHTML = `${days} days ${hours}:${minutes}:${seconds}`;
    } else {
      this.countdownTarget.innerHTML = `${hours}:${minutes}:${seconds}`;
    }
  }
}