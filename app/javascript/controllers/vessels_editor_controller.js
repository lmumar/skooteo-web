import Base from "./base_controller"
import { connect } from "net";

export default class extends Base {
  static targets = [ 'form' ]

  connect() {
    super.connect()
    super.setupActiveStorageHooks()
  }

  disconnect() {
    super.destroyActiveStorageHooks()
  }

  onTabClicked = (e) => {
    e.preventDefault()
    e.stopPropagation()
    const target = e.target.closest('a')
    super.load(target)
    const tabContainer = target.closest('ul')
    const targetContainer = target.closest('li')
    tabContainer.querySelectorAll('li').forEach(el => {
      el.classList.toggle('is-active', el == targetContainer)
    })
  }

  onSubTabClicked = (e) => {
    e.preventDefault()
    e.stopPropagation()
    const target = e.target.closest('a')
    super.load(target)
  }

  get vesselId() {
    return parseInt(this.data.get('id'))
  }
}
