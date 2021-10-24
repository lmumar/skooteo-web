import { request } from 'helpers'
import { Calendar } from "fullcalendar"
import { flatten, groupBy, map, unique } from "underscore"
import moment from "moment"

export default class extends ApplicationController {
  static targets = [ "form", "calendarView", "tabs" ]

  connect() {
    this.calendar = new Calendar(this.calendarViewTarget, {
      defaultView: 'month',
      eventClick: this.onEventClick,
      events: (fetchInfo, successCallback, _failureCallback) => {
        const { start, end } = fetchInfo
        const midpoint = new Date((start.getTime() + end.getTime()) / 2)
        this.fetchCampaigns(moment(midpoint))
          .then(campaigns => {
            const events = this.formatCampaigns(campaigns, this.viewType)
            successCallback(events)
          })
      },
      eventRender: (info) => {
        const extraInfo = info.event.extendedProps.extraInfo
        if (extraInfo) {
          const el = info.el.querySelector('.fc-content')
          let counts = []
          counts = counts.concat([`<li><strong>${extraInfo.campaignCount} campaigns</strong></li>`])
          counts = counts.concat([`<li><strong>${extraInfo.spotCount} spots</strong></li>`])
          counts = counts.concat([`<li><strong>${extraInfo.routeCount} routes</strong></li>`])
          counts = counts.concat([`<li><strong>${extraInfo.tripCount} trips</strong></li>`])
          el.innerHTML = `<ul>${counts.join('')}</ul>`
        }
      }
    })
    this.calendar.render()
    this.viewType = "view_by_campaign"
    window.document.addEventListener("campaigns:updated", () => {
      this.calendar.refetchEvents()
    })
  }

  onEventClick = (info) => {
    let url
    const spots = info.event.extendedProps.spots
    if (spots) {
      const id = spots.map(c => `spot_ids[]=${c.id}`).join('&')
      url = `/media/campaigns/x?${id}&ts=${Date.now()}`
    } else {
      url = `/media/campaigns/${info.event.id}?ts=${Date.now()}`
    }
    request.get(url, { responseKind: 'turbo' }).then(html => Turbo.renderStreamMessage(html))
  }

  onTabChanged = (e) => {
    e.preventDefault()
    const matches = [...this.tabsTarget.querySelectorAll('li')]
    matches.forEach(element => element.classList.toggle('is-active'))
    this.calendar.removeAllEvents()

    this.viewType = this.tabsTarget.querySelector('li.is-active').dataset.tab
    this.calendar.refetchEvents()
  }

  fetchCampaigns(start) {
    return new Promise((resolve, reject) =>
      request
        .getJSON(`/media/campaigns.json?start_date=${start.format('YYYY-MM-DD')}`)
        .then(resolve)
        .catch(reject)
    )
  }

  formatCampaigns(campaigns, viewType = "view_by_campaign") {
    switch (viewType) {
      case "view_by_campaign":
        return this.formatEventByCampaign(campaigns)
      case "view_by_date":
        return this.formatEventByDate(campaigns)
    }
  }

  formatEventByCampaign(campaigns) {
    return campaigns.map(campaign => {
      const color   = this.getEventBackgroundColor(campaign)
      const endDate = moment(campaign.end_date).add(1, 'day')
      return {
        id: campaign.id,
        title: campaign.name,
        start: campaign.start_date,
        end: endDate.format('YYYY-MM-DD'),
        backgroundColor: color,
        borderColor: color
      }
    })
  }

  formatEventByDate(campaigns) {
    const spots  = flatten(map(campaigns, (campaign) => campaign.spots))
    const byDate = groupBy(spots, (spot) => spot.trip_date)
    return map(byDate, (list, tripDate) => {
      const campaignCount = unique(list.map(spot => spot.campaign_id)).length
      const spotCount  = list.length
      const routeCount = unique(list.map(spot => spot.route_id)).length
      const tripCount  = unique(list.map(spot => spot.time_slot_id)).length
      const extraInfo  = { spotCount, routeCount, tripCount, campaignCount }
      return {
        extraInfo,
        start: tripDate,
        title: '',
        spots: list,
        backgroundColor: '#ec4f1f'
      }
    })
  }

  getEventBackgroundColor(campaign) {
    return campaign.has_default_playlists ? '#96948f' :
      (campaign.has_playlists ? '#008c15' : '#ff3860')
  }
}
