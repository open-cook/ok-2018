@OK_Social_widgets = do ->
  init: ->
    !((d, id, did, st) ->

      id = 'ok-script'
      return if d.getElementById(id)

      js = d.createElement('script')
      js.id = id
      js.setAttribute 'type', 'text/javascript'
      js.src = 'https://connect.ok.ru/connect.js'

      js.onload = js.onreadystatechange = ->
        if !@readyState or @readyState == 'loaded' or @readyState == 'complete'
          if !@executed
            @executed = true
            setTimeout (->
              window.OK_Social_widgets.group()
              window.OK_Social_widgets.likes()
            ), 0

      d.documentElement.appendChild js

    )(document)


  group: ->
    OK.CONNECT.insertGroupWidget(
      "ok_group_widget",
      "51283096764610",
      "{width:200,height:285}"
    )

  likes: ->
    try
      for item in $('.ok-like')
        item = $ item
        id  = item.attr('id')
        url = item.attr('url')
        OK.CONNECT.insertShareWidget(
          "#{ id }",
          "#{ url }",
          "{width:165,height:35,st:'rounded',sz:30,ck:1}"
        )
    catch error
      log error

    try
      for item in $('.ok-like-btn2')
        item = $ item
        id  = item.attr('id')
        url = item.attr('url')
        OK.CONNECT.insertShareWidget(
          "#{ id }",
          "#{ url }",
          "{width:165,height:35,st:'rounded',sz:30,ck:1}"
        )
    catch error
      log error
