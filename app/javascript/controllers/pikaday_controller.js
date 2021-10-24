import Pikaday from 'pikaday'
import moment from 'moment'

export default class extends ApplicationController {
  static values = {
    maxDays: Number,
    setDefault: Boolean
  }

  connect() {
    document.addEventListener('pikaday:state', (event) => {
      event.detail.callback(this)
    })

    const defaultDate = moment().toDate()
    const maxDate = this.hasMaxDaysValue ? moment().add(this.maxDaysValue, 'days').toDate() : null

    new Pikaday({
      field: this.element,
      setDefaultDate: this.setDefaultValue || false,
      minDate: defaultDate,
      defaultDate,
      maxDate
    })
  }

  change(_event) {
    this.dispatch(`${this.identifier}:change`)
  }
}
