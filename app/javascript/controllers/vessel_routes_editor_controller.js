import GoogleMapsLoader from 'google-maps'

export default class extends ApplicationController {
  static targets = [
    "distance",
    "form",
    "map",
    "travelDuration",
    "waypoints",
    "coordinates"
  ]

  markers = []

  connect() {
    super.connect()
    this.gmapInit()
    document.getElementById('route_name').focus()
  }

  gmapInit() {
    if (GoogleMapsLoader.isLoaded()) {
      this.initCurrentPosition()
      return
    }

    GoogleMapsLoader.KEY = window.__gmap_api_key
    GoogleMapsLoader.LIBRARIES = ['places', 'geometry']
    GoogleMapsLoader.VERSION = null
    GoogleMapsLoader.load(_google => this.initCurrentPosition())
  }

  initCurrentPosition() {
    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(position => {
        this.renderGmap(window.google, position.coords.latitude, position.coords.longitude)
      }, undefined)
      return
    }
    this.renderGmap(window.google)
  }

  renderGmap(google, plat = 10.3157, plng = 123.8854) {
    let lat = plat
    let lng = plng
    let len = this.coordinatesTargets.length

    if (len) {
      const value = this.coordinatesTargets[0].value
      if (value) {
        const coord = value.substring(1, value.length - 2)
        if (coord) {
          [lng, lat] = coord.split(',')
          lng = lng.trim()
          lat = lat.trim()
        }
      }
    }
	  const distance = (Number(this.distanceTarget.value)/1000).toFixed(2) || 0;
    const center   = new google.maps.LatLng(Number(lat), Number(lng))
    const options  = {
      center,
      zoom: (distance > 1300 ? 10 : 15),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      draggableCursor: 'crosshair'
    }

    this.map = new google.maps.Map(this.mapTarget, options)
    this.vesselPath = new google.maps.Polyline({
      strokeColor: '#FF0000',
      strokeOpacity: 1.0,
      strokeWeight: 2
    })
    this.vesselPath.setMap(this.map)

    google.maps.event.addListener(this.map, 'click', (e) => {
      const marker = this.addMarker(google, e.latLng)
      const lonlat = `(${marker.position.lng()},${marker.position.lat()})`
      const url = `/fleet/vessel_waypoints/new?pos=${this.markers.length-1}&coord=${lonlat}`
      fetch(url)
    })

    this.renderWaypoints(google)
  }

  addMarker(google, latlng) {
    const icon = {
      path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
      fillColor: '#ef5122',
      fillOpacity: 1,
      strokeColor: '#ef5122',
      scale:2,
      strokeWeight: 1
    }
    const marker = new google.maps.Marker({
      position: latlng,
      map: this.map,
      icon: icon
    })
    this.markers.push(marker)

    const path = this.vesselPath.getPath()
    path.setAt(this.markers.length-1, latlng)
    path.push(latlng)

    this.updateDistance(google)

    google.maps.event.addListener(marker, 'rightclick', (_) => {
      const i = this.removeMarker(google, marker)
      if (i >= 0)
        this.removeWaypoint(i)
    })

    return marker
  }

  removeMarker(google, marker) {
    const path = this.vesselPath.getPath()
    const i = this.markers.indexOf(marker)

    if (i < 0)
      return

    this.markers.splice(i, 1)
    marker.setMap(null)
    path.removeAt(i)

    this.updateDistance(google)

    return i
  }

  updateDistance(google) {
    const lenInmeters = google.maps.geometry.spherical.computeLength(this.vesselPath.getPath())
    this.distanceTarget.value = (lenInmeters/1000).toFixed(2)
  }

  removeWaypoint(i) {
    this.waypointsTargets[i].remove()
    this.markers.forEach((_, i) => {
      const el = this.waypointsTargets[i]
      // rails nested fields have index in their name and id,
      // update the indexes to reflect the current situation.
      const inputs = [...el.querySelectorAll('input')]
      inputs.forEach((el) => {
        el.name = el.name.replace(/(.*\[.*\]\[)(\d+)(\].*)/, ("$1" + i + "$3"))
        el.id   = el.id.replace(/(\D+)(\d+)(\D+)/, ("$1" + i + "$3"))
        // also update the sequence with the correct value
        if (el.id.match(/.+_sequence/))
          el.value = i
      })
    })
  }

  renderWaypoints(google) {
    if (this.waypointsTargets.length === 0)
      return

    const rgxlonlat = new RegExp(/\(([+-]?([0-9]*[.])?[0-9]+),\s*([+-]?([0-9]*[.])?[0-9]+)\)/)
    const rgxfield  = new RegExp(/.+_coordinates$/)

    this.waypointsTargets.forEach((el) => {
      const input      = [...el.querySelectorAll('input[type=hidden]')].find((input) => rgxfield.test(input.id))
      const matches    = rgxlonlat.exec(input.value)
      const [lng, lat] = [Number(matches[1]), Number(matches[3])]
      const lonlat     = new google.maps.LatLng({lat, lng})
      this.addMarker(google, lonlat)
    })
  }
}
