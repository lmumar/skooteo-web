import { Controller } from "stimulus"
import Cookie from "js-cookie"

export default class extends Controller {
  connect() {
    this.removeInaccessibleMenus()
    this.setActiveMenu()
  }

  removeInaccessibleMenus() {
    const currentRole = Cookie.get("role")
    const nodes = [...document.querySelectorAll(".sidebar-nav")]
    const matches = nodes.filter(node => {
      const roles = JSON.parse(node.dataset.role)
      return !roles.includes(currentRole)
    })
    matches.forEach(node => node.remove())
  }

  setActiveMenu() {
    const currentCtlName = document.getElementsByTagName('body')[0].dataset.controller_name
    const matches = document.querySelectorAll(`[data-class='${currentCtlName}']`)
    matches.forEach(node => {
      const links = [...node.getElementsByTagName("a")]
      links.forEach(link => link.classList.add("active"))
    })
  }
}
