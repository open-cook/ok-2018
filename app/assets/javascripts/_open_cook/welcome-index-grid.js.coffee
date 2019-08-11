@WelcomeIndexGrid = do ->
  init: ->
    if (block = $('@welcome-index-grid')).length
      if $(window).width() > 1350
        block.css { width: 1330 }
