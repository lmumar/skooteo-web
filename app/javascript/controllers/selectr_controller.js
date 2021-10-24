import Selectr from 'mobius1-selectr'

export default class extends ApplicationController {
  static values = { multiple: Boolean }

  connect() {
    new Selectr(this.element, { multiple: this.multipleValue })
  }
}
