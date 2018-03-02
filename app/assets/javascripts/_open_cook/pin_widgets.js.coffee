window.PIN_Social_widgets = do ->
  init: ->
    !((doc, id, did, st) ->
      id = 'pin-script'
      return if doc.getElementById(id)

      js = doc.createElement('script')
      js.id = id
      js.src = '//assets.pinterest.com/js/pinit.js'
      js.setAttribute 'type', 'text/javascript'

      doc.documentElement.appendChild js

    )(document)
