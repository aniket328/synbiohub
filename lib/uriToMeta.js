var uriToUrl = require('./uriToUrl')

function uriToMeta (uri) {
  var persId
  var version
  if (uri.toString().lastIndexOf('/')) {
    version = uri.toString().slice(uri.toString().lastIndexOf('/') + 1)
    if (version.match(/^\d/)) {
      persId = uri.toString().substring(0, uri.toString().lastIndexOf('/'))
    } else {
      version = ''
      persId = uri.toString()
    }
    id = persId.toString().slice(persId.toString().lastIndexOf('/') + 1)
  }

  return {
    uri: uri + '',
    id: id,
    version: version,
    name: id,
    url: uriToUrl(uri)
  }
}

module.exports = uriToMeta
