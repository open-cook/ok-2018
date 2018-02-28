@TopMenu = do ->
  init: ->
    menu_btns = $('@top_menu--menu-link')
    menus = $('@top_menu--menu_holder @top_menu--ul')

    menu_btns.on 'mouseout', (e) ->
      $('@top_menu--menu_holder @top_menu--ul').hide()

    menu_btns.on 'mouseover', (e) ->
      link = $ e.currentTarget
      role = link.data('menu')
      menu = $("@#{ role }")
      $('@top_menu--menu_holder @top_menu--ul').not(menu).hide()
      menu.show()

    menus.on 'mouseover', (e) ->
      menu = $ e.currentTarget
      menu.show()

    menus.on 'mouseout', (e) ->
      $('@top_menu--menu_holder @top_menu--ul').hide()

