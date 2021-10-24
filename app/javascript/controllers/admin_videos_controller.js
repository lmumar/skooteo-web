import { request } from "helpers"

export default class extends ApplicationController {
  static targets = [ "previewPane", "videoList", "approve", "reject" ]

  connect() {
    super.connect()
    this.initializePreviewpane()
  }

  initializePreviewpane() {
    if (this.videoListTarget.rows.length < 1)
      return

    const status = this.videoListTarget.rows[1].dataset.status
    this.setupPreviewbuttons(status)
  }

  onShowvideo = (e) => {
    e.preventDefault()

    const url     = e.target.parentNode.dataset.url
    const name    = e.target.parentNode.cells[0].innerText

    const heading = this.previewPaneTarget.querySelector(".panel-heading")
    const preview = this.previewPaneTarget.querySelector("video")

    heading.innerText = name
    preview.src = url

    this.previewPaneTarget.dataset.video_id = e.target.parentNode.dataset.id
    this.setupPreviewbuttons(e.target.parentNode.dataset.status)
  }

  onApprovevideo = (e) => {
    const id = this.previewPaneTarget.dataset.video_id
    this.request(`/admin/videos/${id}/approve`, () => {
      this.setupPreviewbuttons('screened')
      this.updateCachedstatus(id, 'screened')
    })
  }

  onRejectvideo = (e) => {
    const id = this.previewPaneTarget.dataset.video_id
    this.request(`/admin/videos/${id}/reject`, () => {
      this.setupPreviewbuttons('rejected')
      this.updateCachedstatus(id, 'rejected')
    })
  }

  setupPreviewbuttons(status) {
    if (
      status === 'approved' ||
      status === 'screened'
    ) {
      this.approveTarget.disabled = true;
      this.rejectTarget.disabled = false;
    }
    else if (status === 'rejected') {
      this.approveTarget.disabled = false;
      this.rejectTarget.disabled = true;
    }
    else if (status === 'pending') {
      this.approveTarget.disabled = false;
      this.rejectTarget.disabled = false;
    }
  }

  request(url, callback) {
    request.post(url).then(callback)
  }

  updateCachedstatus(id, status) {
    const row = this.videoListTarget.querySelector(`[data-id="${id}"]`)
    row.cells[1].innerText = status
  }
}
