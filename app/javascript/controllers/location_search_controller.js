export default class extends ApplicationController {
  static targets = [ "query" ]

  keypress(e) {
    const keyCode = e.keyCode ? e.keyCode : e.which
    if (keyCode !== 13)
      return

    const params = new URLSearchParams(location.search)
    params.set('q', this.queryTarget.value)
    history.pushState(null, null, `${location.pathname}?${params}`)
    history.go()
  }
}
