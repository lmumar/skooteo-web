import { request } from 'helpers'

export default class extends ApplicationController {
  static values  = { id: Number }
  static classes = [ "selected" ]

  initialize() {
    this.selected = false
  }

  connect() {
    document.addEventListener('selectable:state', (event) => {
      event.detail.callback(this)
    })
  }

  toggle(e) {
    this.selected = !this.selected
    this.element.classList.toggle(this.selectedClass)
    this.dispatch(`${this.identifier}:toggle`)
  }
}
