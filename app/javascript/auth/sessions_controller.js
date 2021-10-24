import { Controller } from "stimulus"

export default class extends Controller {
  change(e) {
    const email = document.getElementById('user_email').value
    const password = document.getElementById('user_password').value
    const submit = document.querySelectorAll('button')[0]
    submit.disabled = !email || !password
  }
}
