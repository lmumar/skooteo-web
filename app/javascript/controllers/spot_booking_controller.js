import { round2, formatCurrency, formatNumber } from 'helpers'
import { debounce, isEmpty } from 'underscore'
import { request } from 'helpers'

export default class extends ApplicationController {
  static values = { totalCredits: Number }

  static targets = [
    "form", "regularBookings", "premiumBookings", "capacities",
    "regularTotalCost", "premiumTotalCost", "regularTotalCount",
    "premiumTotalCount", "totalCost", "numDaysToClone", "totalCredits",
    "credits"
  ]

  connect() {
    this.updateTotals = debounce(this.updateTotals, 300)
  }

  close() {
    this.element.remove()
    window.location.reload()
  }

  submit = (e) => {
    if (this.formTarget.checkValidity()) {
      e.target.classList.add("is-loading")
      return true
    } else {
      this.formTarget.reportValidity()
      return false
    }
  }

  onBookSpot = (e) => this.updateTotals()

  updateTotals() {
    let totalRegCost  = 0.0, totalPreCost = 0.0
    let totalRegCount = 0, totalPreCount = 0

    this.regularBookingsTargets.forEach((regularBooking, i) => {
      const regular = Number(regularBooking.value) || 0
      const premium = Number(this.premiumBookingsTargets[i].value) || 0
      const credits = Number(this.creditsTargets[i].value) || 0

      totalRegCost += regular * credits
      totalPreCost += premium * credits

      totalRegCount += regular
      totalPreCount += premium
    })

    let ndays = 1
    if (this.hasNumDaysToCloneTarget)
      ndays = (parseInt(this.numDaysToCloneTarget.value) || 0) + 1

    let totalCost = round2((totalRegCost + totalPreCost) * ndays)

    this.regularTotalCostTarget.innerText = formatCurrency(totalRegCost * ndays)
    this.premiumTotalCostTarget.innerText = formatCurrency(totalPreCost * ndays)

    this.regularTotalCountTarget.innerText = formatNumber(totalRegCount * ndays)
    this.premiumTotalCountTarget.innerText = formatNumber(totalPreCount * ndays)

    this.totalCostTarget.innerText = formatCurrency(totalCost)
    this.totalCreditsTarget.innerText = formatCurrency(this.totalCreditsValue - totalCost)
  }
}
