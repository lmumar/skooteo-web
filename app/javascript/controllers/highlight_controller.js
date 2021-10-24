export default class extends ApplicationController {
  static targets = [ "item" ]
  static values  = { selected: Number }

  connect() {
    this.selected = this.selectedValue
    this.highlight()
  }

  select(event) {
    this.selected = parseInt(event.currentTarget.dataset.key)
    this.highlight()
  }

  highlight() {
    this.itemTargets.forEach((el, _) => {
      const key = parseInt(el.dataset.key)
      if (key === this.selected)
        el.classList.add('is-active')
      else
        el.classList.remove('is-active')
    })
  }
}