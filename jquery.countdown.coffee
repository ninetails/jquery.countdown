# dependencies
jQuery = jQuery || {}
module = module || {}
window = window || {}

do ($ = jQuery, module, window) ->
  if module.exports?
    module.exports = (what) ->
      'Hello ' + what + '!'
