export default class extends ApplicationController {
  static targets = [ "month", "year", "status" ]

  apply(event) {
    const basePath = this.element.dataset.basepath
    const el = document.getElementById("edit_route")

    let url = new URL(basePath)
    let params = url.searchParams

    let mm = this.monthTarget.options[this.monthTarget.selectedIndex]
    let yyyy = this.yearTarget.options[this.yearTarget.selectedIndex]

    params.append('inactive', this.statusTarget.value == 'active' ? '0' : '1')
    params.append('mm', mm.value)
    params.append('yyyy', yyyy.value)

    el.src = url.toString()
  }
}
