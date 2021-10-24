import Base from "./base_controller"
import gmaps from 'google-maps'
import firebase from 'firebase/app'
import 'firebase/database'
import { compact, reduce } from 'underscore'

const VesselStatus = Object.freeze({
  arrived: 0,
  onCourse: 2,
  waiting: 5,
  noGPS: 6,
  noTrip: 8
})

function avg(ns) {
  return reduce(compact(ns), (acc, n) => acc + (n || 0), 0)/ns.length
}

function recenter(map, len) {
  let mapData  = []
  let centered = false
  return (position) => {
    if (mapData.length < len) {
      mapData.push(position)
      return
    }

    if (mapData.length === len && centered)
      return

    const parts = reduce(mapData, (list, o) => {
      list[0].push(o.lat)
      list[1].push(o.lng)
      return list
    }, [[], []])

    const alat = avg(parts[0])
    const alng = avg(parts[1])

    map.setCenter({lat: alat, lng: alng})
    map.setZoom(10)
    centered = true
  }
}

export default class extends Base {
  static targets = [ 'map', 'vessel' ]
  vesselMapData = []

  connect() {
    super.connect()
    if (!this.inPreview && this.hasMapTarget) {
      this.firebaseInit()
      this.gmapInit()
    }
  }

  disconnect() {
    if (this.hasMapTarget) {
      gmaps.release()
    }
  }

  gmapInit() {
    gmaps.KEY = window.__gmap_api_key
    gmaps.LIBRARIES = ['places', 'geometry']
    gmaps.VERSION = null
    gmaps.load(google => {
      this.google = google
      this.renderMap(google)
      this.initVesselMapData(google)
      this.showCurrentVessel(google)
    })
  }

  initVesselMapData(google) {
    this.vesselTargets.forEach((el, i) => {
      const target = el.closest('[data-id]')
      const id = target.dataset.id
      const name = target.dataset.name
      const marker = new google.maps.Marker()
      const infoWindow = new google.maps.InfoWindow({
        content: name
      })
      infoWindow.open(this.map, marker)
      const dbref = this.database.ref(`node-statuses/${id}`)

      dbref.once('value').then((snapshot) => {
        setTimeout(() => {
          this.updateVessel(google, snapshot, i);
        }, 1000)
      })

      dbref.on('value', (snapshot) => {
        this.updateVessel(google, snapshot, i);
      })
      this.vesselMapData[i] = { id, name, dbref, marker, infoWindow }
    })
  }

  updateVessel(google, snapshot, i){
    const centerMap = recenter(this.map, this.vesselTargets.length);
    const fbData = snapshot.val();
    if (!fbData) return;
    const mapData = this.vesselMapData[i];
    this.transition(mapData, fbData, google);
    const position = fbData ? { lat: fbData.lat, lng: fbData.lng } : null;
    if (this.index >= 0) centerMap(position);
  }

  get inPreview() {
    return document.documentElement.hasAttribute("data-turbolinks-preview")
  }

  renderMap(google) {
    const center = new google.maps.LatLng(10.3157, 123.8854)
    const options = {
      center,
      zoom: 10,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    this.map = new google.maps.Map(this.mapTarget, options)
  }

  firebaseInit() {
    if (firebase.apps.length === 0) {
      const config = {
        apiKey: "AIzaSyDbiX0_9tdcTA_0a1Bgvem-oRXiSIwR90w",
        authDomain: "skooteo-node-device.firebaseapp.com",
        databaseURL: "https://skooteo-node-device.firebaseio.com",
        projectId: "skooteo-node-device",
        storageBucket: "skooteo-node-device.appspot.com",
        messagingSenderId: "194313618000",
      }
      firebase.initializeApp(config)
    }
    this.database = firebase.database()
  }

  delete = (e) => {
    swal({
      title: "Are you sure?",
      text: "Once deleted, you will not be able to recover this vessel!",
      icon: "warning",
      buttons: true,
      dangerMode: true,
    })
      .then((willDelete) => {
        if (willDelete) {
          const path = e.target.dataset.delete_path
          Rails.ajax({
            type: 'DELETE',
            url: path,
            complete: () => this.close()
          })
        }
      })
  }

  onSelectVessel = (e) => {
    e.preventDefault()
    const el = e.target.closest('[data-id]')
    this.index = parseInt(el.dataset.index)
  }

  onFilterApplied = () => {
    if (this.hasMapTarget) {
      this.gmapInit()
      this.firebaseInit()
    }
  }

  transition(mapData, fbData, google) {
    const { id, name, marker, infoWindow } = mapData
    const { track, lat, lng, eta, trip_status } = fbData
    const latlng = new google.maps.LatLng(lat, lng)
    const url = `/images/vessel-marker.png?id=${id}`
    marker.setPosition(latlng)
    marker.setIcon({
      map: this.map,
      scaledSize: new google.maps.Size(32, 32),
      optimized: false,
      url
    })

    const info = [`<div>${name}</div>`]
    if (trip_status === VesselStatus.noTrip)
      info.push(`<div><strong>No Trips</strong></div>`)
    else if (trip_status === VesselStatus.arrived)
      info.push('<div>Arrived</div>')
    else if (trip_status === VesselStatus.onCourse) {
      let eta_text = '- hr - mins'
      if (!!eta) {
        eta_text = `${Math.floor(eta / 60)} hr ${Math.round(eta % 60)} min`
      }
      info.push(`<div><strong>ETA:</strong> ${eta_text} </div>`)
    } else if (trip_status === VesselStatus.noGPS)
      info.push(`<div><strong>Waiting(NO GPS)</strong></div>`)
    else if (trip_status === VesselStatus.waiting)
      info.push(`<div><strong>Waiting</strong></div>`)

    infoWindow.setContent(info.join(''))
    const img = document.querySelector(`img[src="${url}"]`)
    if (img){
      let lastTrack = img.getAttribute("data-last-track");
      let trackCheckCount = img.getAttribute("data-track-check-count") || 0
      const trackCheckMaxCount = 4
      if (lastTrack && track === 0 && trackCheckCount < trackCheckMaxCount) {
        img.setAttribute("data-track-check-count", ++trackCheckCount);
        return;
      } else if (trackCheckCount >= trackCheckMaxCount) {
               img.setAttribute("data-track-check-count", 0);
             }
      img.setAttribute("data-last-track", track)
      img.style.transform = `rotate(${track}deg)`
    }

  }

  get index() {
    return parseInt(this.data.get("index"))
  }

  set index(value) {
    this.data.set("index", value)
    this.showCurrentVessel(this.google)
  }

  showCurrentVessel(google) {
    this.vesselTargets.forEach((el, i) => {
      el.classList.toggle('is-active', i === this.index)
      const mapData = this.vesselMapData[i]
      mapData.marker.setMap(null)
      if (i === this.index || this.index < 0) {
        mapData.marker.setMap(this.map);
        const target = el.closest("[data-id]");
        const id = target.dataset.id;
        const dbref = this.database.ref(`node-statuses/${id}`);
        dbref.once("value").then((snapshot) => {
          setTimeout(() => {
            this.updateVessel(google, snapshot, i);
          }, 1000);
        });
      }
    })
  }
}
