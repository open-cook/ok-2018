window.TW_Social_widgets = do ->
  init: ->
    !((d, id, did, st) ->
      id = 'twitter-script'
      return if d.getElementById(id)

      js = d.createElement('script')
      js.id = id
      js.setAttribute 'type', 'text/javascript'
      js.src = 'https://platform.twitter.com/widgets.js'

      d.documentElement.appendChild js
    )(document)
