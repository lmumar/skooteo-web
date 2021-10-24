export default class extends ApplicationController {
  static values = { elementId: String }

  close(_event) {
    if (this.hasElementIdValue) {
      const el = document.getElementById(this.elementIdValue)
      el.remove()
    } else {
      this.element.remove()
    }
  }
}
