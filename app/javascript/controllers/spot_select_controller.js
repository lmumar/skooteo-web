import Selectr from 'mobius1-selectr'
import moment from 'moment'
import { debounce, unique, reject } from 'underscore'
import { request } from 'helpers'

export default class extends ApplicationController {
  static targets = [ "calculate", "companies", "origins", "destinations", "routesSelectedInfo", "routeSearchResults", "startDate" ]

  connect() {
    super.connect()
    this.selectedRouteIds = []
    this.fetchRoutes = debounce((params) => {
      const url = `/fleet/vessel_routes.json?${params.join('&')}`
      request.getJSON(url).then(this.onRoutesFetched)
    }, 1000)
    new Selectr(this.companiesTarget, {multiple: true})
    document.addEventListener('selectable:toggle', (event) => {
      const detail = {
        callback: (selectableController) => {
          if (selectableController.selected)
            this.selectedRouteIds.push(selectableController.idValue)
          else
            this.selectedRouteIds = reject(this.selectedRouteIds, (id) => id === selectableController.idValue)
          this.updateRouteSelectionInfo()
        }
      }
      this.dispatch('selectable:state', { detail, target: document })
    })
  }

  onCalculateSpots = (e) => {
    e.preventDefault()

    const els = [...this.routeSearchResultsTarget.querySelectorAll('.box.is-active')]
    const startDate = this.startDateTarget.value
    const data = `ts=${Date.now()}&start_date=${startDate}&${this.selectedRouteIds.map(id => `route_ids[]=${id}`).join('&')}`

    request.get(`/media/spots/new?${data}`, { responseKind: "turbo"})
      .then(html => Turbo.renderStreamMessage(html))
  }

  onSelectCompanies = (e) => {
    const selected = [...e.target.querySelectorAll('option:checked')]
    if (selected.length === 0) {
      this.fetchRoutes.cancel()
      this.replaceOptions(this.originsTarget, ['Origin'])
      this.replaceOptions(this.destinationsTarget, ['Destination'])
      this.originsTarget.disabled = true
      this.destinationsTarget.disabled = true
      return
    }
    const values = selected.map(el => `company_ids[]=${el.value}`)
    this.fetchRoutes(values)
  }

  onRoutesFetched = (routes) => {
    const [origin, destination] = routes.reduce((parts, route) => {
      parts[0].push(route.origin)
      parts[1].push(route.destination)
      return parts
    }, [[], []])
    this.replaceOptions(this.originsTarget, unique(origin).sort())
    this.replaceOptions(this.destinationsTarget, unique(destination).sort())
    this.originsTarget.disabled = false
    this.destinationsTarget.disabled = false
  }

  updateRouteSelectionInfo() {
    if (this.selectedRouteIds.length > 0) {
      this.routesSelectedInfoTarget.innerText = `${this.selectedRouteIds.length} Route(s) selected`
      this.routesSelectedInfoTarget.previousElementSibling.classList.remove('is-hidden')
      this.calculateTarget.disabled = false
    } else {
      this.calculateTarget.disabled = true
      this.routesSelectedInfoTarget.innerText = ''
      this.routesSelectedInfoTarget.previousElementSibling.classList.add('is-hidden')
    }
  }

  replaceOptions(select, options) {
    select.innerText = null
    if (options.length) options.unshift('')
    options.forEach(opt => {
      const option = document.createElement("option")
      option.text = opt
      select.options.add(option)
    })
  }

  search(e) {
    this.selectedRouteIds = []
  }
}
