export default class extends ApplicationController {
  static targets = [ 'file', 'preview' ]

  change(event) {
    event.preventDefault()
    this.fileTarget.click();
  }

  changed() {
    if (!this.fileTarget.files || !this.fileTarget.files[0]) return

    const file = this.fileTarget.files[0]
    const reader = new FileReader()
    reader.onload = e => {
      this.previewTarget.src = e.target.result
    }
    reader.readAsDataURL(file)
  }
}
