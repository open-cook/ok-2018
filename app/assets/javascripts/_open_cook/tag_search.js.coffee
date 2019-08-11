@TagSearch = do ->
  init: ->
    # Default random tags to show
    tags = $("@tags-search--tag")
    tags = tags.sort((a, b) ->
      x = Math.floor(Math.random() * 2)
      (if x is 0 then -1 else 1)
    )

    _tags = tags.slice(0, 3).clone()
    $("@tags-search--tag-result").empty().append _tags

    # oncahnge on input
    $("@tags-search--tag-word").keyup (event) ->
      input = $(event.target)
      word = input.val().toLowerCase()
      return false  if word is ""
      num = parseInt(word)
      int_search = false
      int_search = true  if num > 0  if typeof (num) is "number"
      tags = $("@tags-search--tag")
      finded = []
      $("@tags-search--tag-storage").hide()
      $("@tags-search--tag-result").show()

      # search by counter
      if int_search
        tags.each (i, tag) ->
          counter = $(tag).data("count")
          counter = parseInt(counter)
          finded.push tag  if num is counter
          return

      else
        # search by word
        tags.each (i, tag) ->
          _tag = $(tag).data("tag")
          finded.push tag  if _tag.match(word)?
          return

        finded.sort (a, b) ->
          pattern = new RegExp("^" + word)
          a = $(a).data("tag")
          b = $(b).data("tag")
          a = a.match(pattern)
          b = b.match(pattern)
          if a is null
            1
          else
            -1

      $("@tags-search--tag-result").empty().append $(finded).clone()

      return

    return
