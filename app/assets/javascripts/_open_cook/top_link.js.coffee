window.TopLink = do ->
  init: ->
    base_screen_height = $("body").height()

    $(window).scroll ->
      if window.pageYOffset > base_screen_height
        $("#to_top:hidden").fadeIn()
      else
        $("#to_top:visible").fadeOut()
