export default class extends ApplicationController {
  open(e) {
    e.preventDefault()
    this.element.classList.remove('is-hidden')
  }

  close(e) {
    e.preventDefault()
    this.element.classList.add('is-hidden')
  }
}
