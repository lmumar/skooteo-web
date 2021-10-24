import numeral from 'numeral'

export function round2(n) {
  return Math.round((n*100).toFixed(2))/100
}

export function formatCurrency(n) {
  return numeral(n).format('0,0.00')
}

export function formatNumber(n) {
  return numeral(n).format('0,0')
}
