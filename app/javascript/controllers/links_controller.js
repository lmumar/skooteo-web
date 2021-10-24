import { request } from "helpers"

export default class extends ApplicationController {
  static values = { url: String, method: String, turbo: Boolean }

  visit(event) {
    event.preventDefault()
    event.stopPropagation()
    this.turboValue ? request.getTurbo(this.url) : request[this.methodValue](this.url)
  }

  get url() {
    return this.element.href || this.urlValue
  }
}
