import swal from "sweetalert";
import Sortable from "sortablejs"
import { request } from "helpers"

export default class extends ApplicationController {

  initialize() {
    this.playlistNs = this.data.get("ns") || "media"
  }

  connect() {
    super.connect();
    document.querySelectorAll(".sortable").forEach(e => {
      Sortable.create(e, {
        onEnd: this.onEnd,
        onMove: this.onMove
      })
    })
  }

  onEnd = e => {
    if (!e.item.querySelector(".video")) return
    const playlistVidId = e.item.querySelector(".video").dataset.playlist_video_id
    const playlistId = e.target.closest(".playlist-container").dataset.id
    const newIndex = e.newIndex
    request.post(`/${this.playlistNs}/playlist_videos/${playlistVidId}/set_play_order?playlist_id=${playlistId}&play_order=${newIndex}`)
  };

  onMove = e => !e.dragged.classList.contains("fixed")

  onRemovePlaylistVideo = e => {
    e.preventDefault();
    swal({
      title: "Are you sure you want to remove this video from the playlist?",
      icon: "warning",
      buttons: true,
      dangerMode: true
    }).then(willRemove => {
      if (!willRemove) return
      const id = e.target.dataset.playlist_video_id
      request.delete(`/${this.playlistNs}/playlist_videos/${id}`)
    })
  }

  onDelete = e => {
    e.preventDefault();
    swal({
      title: "Are you sure you want to delete this playlist?",
      text: "Once deleted you will not be able to recover this playlist!",
      icon: "warning",
      buttons: true,
      dangerMode: true
    }).then(willDelete => {
      if (!willDelete) return;

      const plist = e.target.closest(".playlist-container")
      const pid = plist.dataset.id
      request.delete(`/${this.playlistNs}/playlists/${pid}`)
    });
  };
}
