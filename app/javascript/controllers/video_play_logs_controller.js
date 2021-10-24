import Base from './base_controller'
import Pikaday from 'pikaday'

export default class extends Base {
  static targets = ['form', 'startDate', 'endDate']

  connect() {
    super.connect()
    this.initDateControls()
  }

  initDateControls() {
    const defaultDate  = new Date()
    const dateControls = [this.startDateTarget, this.endDateTarget]
    dateControls.forEach(ctl =>
      new Pikaday({
        field: ctl,
        setDefaultDate: true,
        defaultDate
      }))
  }

  closeModal = e => {
    e.preventDefault()
    this.element.classList.toggle('is-active')
  }
}