@UserCabinetAnchors = do ->
  init: ->
    if (anchor = window.location.hash.substring(1)).length
      try
        $("[name=#{ anchor }]").addClass 'highlighted'
      catch e
        log e.message
