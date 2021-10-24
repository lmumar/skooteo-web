export default class extends ApplicationController {

  static targets = [ "regAdsDuration", "prmAdsDuration", "regAdsSeglen", "prmAdsSeglen",
    "onboarding", "offboarding", "travelTime", "onboardingStat", "onboardingPctStat", "totalAdsStat",
    "offboardingStat", "offboardingPctStat", "totalAdsStat", "totalPlaybackStat", "totalAdsPctStat"
  ]

  connect() {
    this.update()
  }

  update(_event) {
    this.totalAdsPctStatTarget.style.width    = `${this.adsDuration / this.travelTime * 100}%`
    this.onboardingPctStatTarget.style.width  = `${this.onboardingDuration / this.travelTime * 100}%`
    this.offboardingPctStatTarget.style.width = `${this.offboardingDuration / this.travelTime * 100}%`

    this.onboardingStatTarget.innerText    = `On-boarding: ${this.onboardingDuration.toFixed(2)} minutes`
    this.offboardingStatTarget.innerText   = `Off-boarding: ${this.offboardingDuration.toFixed(2)} minutes`
    this.totalAdsStatTarget.innerText      = `Ads: ${this.adsDuration.toFixed(2)} minutes`
    this.totalPlaybackStatTarget.innerText = `Entertainment: ${this.totalEntPlayback.toFixed(2)} minutes`
  }

  get adsDuration() {
    return this.regAdsDuration + this.prmAdsDuration
  }

  get regAdsDuration() {
    return this.getDuration(this.regAdsDurationTargets)
  }

  get prmAdsDuration() {
    return this.getDuration(this.prmAdsDurationTargets)
  }

  get onboardingDuration() {
    return this.getDuration(this.onboardingTargets)
  }

  get offboardingDuration() {
    return this.getDuration(this.offboardingTargets)
  }

  get travelTime()          {
    return this.getDuration(this.travelTimeTargets)
  }

  get totalMediaPlayback()  {
    return this.offboardingDuration + this.onboardingDuration + this.adsDuration
  }

  get totalEntPlayback()    {
    return this.travelTime - this.totalMediaPlayback
  }

  getDuration(targets) {
    const [ elHH, elMM, elSS ] = targets
    const [ hh, mm, ss ] = [ elHH.value || '0', elMM.value || '0', elSS.value || '0' ]
    return Number(hh) * 60 + Number(mm) + Number(ss) / 60
  }
}
