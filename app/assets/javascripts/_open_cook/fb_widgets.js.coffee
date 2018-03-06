@FB_Social_widgets = do ->
  init: ->
    !((doc, id, did, st) ->
      id  = 'facebook-jssdk'
      id2 = 'fb-root'

      return if doc.getElementById(id)

      root = doc.createElement('div')
      root.id = id2
      doc.documentElement.appendChild root

      js = doc.createElement('script')
      js.id = id
      js.src = '//connect.facebook.net/ru_RU/sdk.js#xfbml=1&version=v2.5&appId=263525720524797'
      js.setAttribute 'type', 'text/javascript'

      doc.documentElement.appendChild js

    )(document)
