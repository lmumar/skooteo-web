import swal from "sweetalert"
import { request } from 'helpers'

export default class extends ApplicationController {
  static values = { url: String, message: String, method: String }

  trigger(_event) {
    swal(this.messageValue, {
      content: 'input',
      buttons: ['Cancel', 'Confirm']
    })
    .then((value) => {
      let formData = new FormData()
      formData.append('value', value)
      request(this.methodValue, this.urlValue, { body: formData })
    })
  }
}
