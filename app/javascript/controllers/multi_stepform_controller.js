import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step"]

  connect() {
    this.currentStep = 0
    this.showStep()
  }

  next() {
    if (this.currentStep < this.stepTargets.length - 1) {
      this.currentStep++
      this.showStep()
    }
  }

  previous() {
    if (this.currentStep > 0) {
      this.currentStep--
      this.showStep()
    }
  }

  showStep() {
    this.stepTargets.forEach((el, index) => {
    const isActive = index === this.currentStep;
    el.hidden = !isActive;

    // Disable all inputs in inactive steps
    el.querySelectorAll("input, select, textarea, button").forEach(input => {
      input.disabled = !isActive;
    });
  });
  }
}
