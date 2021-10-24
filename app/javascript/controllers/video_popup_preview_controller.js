export default class extends ApplicationController {
  static values = { previewUrl: String }

  preview(e) {
    e.preventDefault()
    let video = document.createElement("video")
    video.controls = true
    video.src = this.previewUrlValue
    swal({
      closeOnClickOutside: true,
      content: video
    }).then(_ => {
      video.pause()
      video.removeAttribute("src")
    })
  }
}
