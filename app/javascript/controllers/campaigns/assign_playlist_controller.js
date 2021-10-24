import { database } from 'firebase'
import { request } from 'helpers'

export default class extends ApplicationController {
  static targets = [ "playlistsModalContent" ]
  static values = { spotIds: String }

  connect() {
    this.showPlaylists = this.showPlaylists.bind(this)
  }

  showPlaylists(e) {
    e.preventDefault()
    swal({
      text: "Select playlist to assign to this campaign",
      content: this.playlistsModalContentTarget.cloneNode(true),
      buttons: [
        true,
        "Use playlist"
      ]
    })
    .then((value) => {
      if (!value) return
      const regular = document.querySelector('.swal-modal #regular_playlists')
      const premium = document.querySelector('.swal-modal #premium_playlists')
      this.setPlaylist(regular.value, premium.value)
    })
  }

  setPlaylist(regularPlaylistId, premiumPlaylistId) {
    const formData = new FormData()
    this.spotIdsValue.split(',').forEach(spotId => formData.append('spot_ids[]', spotId))
    formData.set('regular_playlist_id', regularPlaylistId)
    formData.set('premium_playlist_id', premiumPlaylistId)
    const dispatch = this.dispatch
    request.post('/media/campaigns/set_playlist', {
      responseKind: "turbo",
      body: formData
    }).then(html => {
      Turbo.renderStreamMessage(html)
      dispatch("campaigns:updated", { target: document })
      swal({
        title: "Playlist assigned!",
        icon: "success"
      })
    })
  }
}
