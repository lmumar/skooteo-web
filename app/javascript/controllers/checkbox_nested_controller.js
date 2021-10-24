export default class extends ApplicationController {
  tick(event) {
    if (!this.element.checked) {
      const [prefix, index, _] = this.element.id.split(/(\d)/)
      const hiddenID = `${prefix}${index}__destroy`
      document.getElementById(hiddenID).value = '1'
    }
  }
}
