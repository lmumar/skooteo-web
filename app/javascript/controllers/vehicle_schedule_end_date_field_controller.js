import moment from 'moment'

export default class extends ApplicationController {
  connect() {
    document.addEventListener('pikaday:change', (event) => {
      const detail = {
        callback: (pikadayController) => {
          if (pikadayController.element.id !== 'vehicle_schedule_template_effective_start_date')
            return

          const label = document.getElementById('vehicle_schedule_end_date_label')
          const startDate = moment(pikadayController.element.value)
          const endDate = startDate.add(7, 'days').format('YYYY-MM-DD')

          label.innerText = endDate
          this.element.value = endDate
        }
      }
      this.dispatch('pikaday:state', { detail, target: document })
    })
  }
}
