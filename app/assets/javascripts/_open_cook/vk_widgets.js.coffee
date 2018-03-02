window.VK_Social_widgets = do ->
  init: ->
    !((d, id, did, st) ->

      id = 'vk-script'
      return if d.getElementById(id)

      js = d.createElement('script')
      js.id = id
      js.setAttribute 'type', 'text/javascript'
      js.src = 'https://userapi.com/js/api/openapi.js?49'

      js.onload = js.onreadystatechange = ->
        if !@readyState || @readyState is 'loaded' || @readyState is 'complete'
          if !@executed
            @executed = true
            setTimeout (->

              VK.init
                apiId: 2924934
                onlyWidgets: true

              VK.Widgets.Group 'vk_groups', {
                mode: 0
                width: '200'
                height: '300'
                color1: 'EFEFFD'
                color2: '2B587A'
                color3: '5B7FA6'
              }, 38112740

              VK_Social_widgets.likes()
            ), 100

      d.documentElement.appendChild js

    )(document)

  likes: ->
    for item in $('.vk_like')
      item = $ item

      do (item) ->
        vkid      = item.attr('id')
        url       = item.attr('url')
        vk_title  = item.attr('title')
        vk_image  = item.attr('image')
        vk_text   = item.attr('text')
        vk_type   = item.attr('type')
        vk_height = item.attr('height')

        VK.Widgets.Like "#{ vkid }",
          type: vk_type

          pageUrl:         "#{ url }"
          pageTitle:       "#{ vk_title }"
          pageDescription: "#{ vk_title }"
          text:            "#{ vk_text }"

          pageImage: "#{ vk_image }"
          image:     "#{ vk_image }"
          imageUrl:  "#{ vk_image }"

          height: "#{ vk_height }"
