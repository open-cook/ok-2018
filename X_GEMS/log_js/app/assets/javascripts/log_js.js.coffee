window.LogJS = do ->
  init: ->
    @enable ||= $('[data-log-js]').length

window.log = ->
  try
    if LogJS.enable
      console.log arguments...

$ -> do LogJS.init
