function constructUrl(pathname) {
  if (pathname.indexOf('http') >= 0) {
    return new URL(pathname)
  } else {
    const {protocol, host} = window.location
    const npathname = `${protocol}//${host}${pathname}`
    return new URL(npathname)
  }
}

export function appendQueryString(url, key, value) {
  const nurl = constructUrl(url)
  const params = new URLSearchParams(nurl.search)
  params.append(key, value)

  const path = url.split('?')[0]
  return `${path}?${params.toString()}`
}
