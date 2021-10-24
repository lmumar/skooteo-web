import { Controller } from "stimulus"
import Rails from "rails-ujs"
import swal from 'sweetalert'
import { appendQueryString } from 'helpers/url_helpers'

export default class extends Controller {
  static targets = [ "form" ]

  setupActiveStorageHooks() {
    addEventListener("direct-upload:initialize", this.onUploadInit)
    addEventListener("direct-upload:start", this.onUploadBegin)
    addEventListener("direct-upload:progress", this.onUploadProgress)
    addEventListener("direct-upload:error", this.onUploadError)
    addEventListener("direct-upload:end", this.onUploadEnd)
  }

  destroyActiveStorageHooks() {
    removeEventListener("direct-upload:initialize", this.onUploadInit)
    removeEventListener("direct-upload:start", this.onUploadBegin)
    removeEventListener("direct-upload:progress", this.onUploadProgress)
    removeEventListener("direct-upload:error", this.onUploadError)
    removeEventListener("direct-upload:end", this.onUploadEnd)
  }

  onUploadInit = (event) => {
    const { target, detail } = event
    const { id, file } = detail
    target.insertAdjacentHTML("beforebegin", `
      <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
        <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
        <span class="direct-upload__filename">${file.name}</span>
      </div>
    `)
  }

  onUploadBegin = (event) => {
    const { id } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.remove("direct-upload--pending")
  }

  onUploadProgress = (event) => {
    const { id, progress } = event.detail
    const progressElement = document.getElementById(`direct-upload-progress-${id}`)
    progressElement.style.width = `${progress}%`
  }

  onUploadError = (event) => {
    event.preventDefault()
    const { id, error } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add("direct-upload--error")
    element.setAttribute("title", error)
  }

  onUploadEnd = (event) => {
    const { id } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add("direct-upload--complete")
  }

  close() {
    this.element.remove()
  }

  edit(e) {
    e.preventDefault()
    e.stopPropagation()
    const el  = e.target.closest("[data-url]")
    const url = el.dataset.url
    Rails.ajax({
      url,
      type: "GET",
    })
  }

  load(el, replace = false) {
    const url = appendQueryString(el.dataset.contentUrl, 'format', 'html')
    fetch(url)
      .then(response => response.text())
      .then(html => {
        const targetId = el.dataset.contentTarget
        const target = document.getElementById(targetId)
        if (replace) {
          target.outerHTML = html
        } else {
          target.innerHTML = html
        }
      })
  }

  delete = (e) => {
    e.preventDefault()
    const confirmMsg = e.target.dataset.confirm_message ||
      "Once deleted, you will not be able to recover this record!"
    swal({
      title: "Are you sure?",
      text: confirmMsg,
      icon: "warning",
      buttons: true,
      dangerMode: true,
    })
    .then((willDelete) => {
      if (willDelete) {
        const el   = e.target.closest("[data-delete_path]")
        const path = el.dataset.delete_path

        Rails.ajax({
          type: 'DELETE',
          url: path,
          complete: () => this.close()
        })
      }
    })
  }

  save(e) {
    if (this.formTarget.checkValidity()) {
      e.target.classList.add("is-loading")
      this.element.classList.remove("s-modal-sheet")
      this.setupSaveHooks();
      this.formTarget.addEventListener("ajax:complete", (_) => {
        e.target.classList.remove("is-loading");
        Rails.fire(window.document, "ajax:complete");
      })
      this.formTarget.addEventListener("ajax:error", (xhr) => {
        e.target.classList.remove("is-loading");
        const errMsg = typeof xhr.detail[2] === 'object' ? xhr.detail[2].statusText :
          JSON.parse(xhr.detail[2].responseText).errors;
        swal("Error saving record!", errMsg, "error")
      })
      Rails.fire(this.formTarget, 'submit')
    } else {
      this.formTarget.reportValidity()
    }
  }

  setupSaveHooks() {
    this.formTarget.addEventListener("ajax:success", () => {
      swal({
        title: "Saved!",
        icon: "success"
      })
    })
  }

  queryKeyPressed(e) {
    const keyCode = e.keyCode ? e.keyCode : e.which
    if (keyCode !== 13)
      return

    const params = new URLSearchParams(location.search)
    params.set('q', this.queryTarget.value)
    history.pushState(null, null, `${location.pathname}?${params}`)
    history.go()
  }
}