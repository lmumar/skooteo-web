import { request } from 'helpers'
import { reject } from 'underscore'

export default class extends ApplicationController {
  static targets = ["addButton"]

  static values = { endpoint: String }

  initialize() {
    this.selected = []
  }

  connect() {
    document.addEventListener('selectable:toggle', (event) => {
      const detail = {
        callback: (selectableController) => {
          if (selectableController.selected)
            this.selected.push(selectableController.idValue)
          else
            this.selected = reject(this.selected, (id) => id === selectableController.idValue)
          this.toggleAddButton()
        }
      }
      this.dispatch('selectable:state', { detail, target: document })
    })
  }

  toggleAddButton() {
    if (this.selected.length > 0)
      this.addButtonTarget.removeAttribute('disabled')
    else
      this.addButtonTarget.setAttribute('disabled','')
  }

  save(e) {
    if (this.selected.length === 0) return
    request.post(this.endpointValue, {
      responseKind: "json",
      body: JSON.stringify({ video_ids: this.selected })
    })
  }
}
