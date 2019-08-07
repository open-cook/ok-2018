@SearchLine = do ->
  source: (request, response) ->
    if request.term.length > 1
      $.ajax
        type: 'POST'
        url: @element.data('autocomplete-path')
        data: { term: request.term }
        success: (data, status, _response) ->
          response data

  init: ->
    $('@search_line_form').on 'submit', (e) ->
      form  = $ e.currentTarget
      query = $('@search_line', form).val()

      return false unless query.length

      url = form.attr('action') + query
      $('[name=utf8], [name=squery]', form).removeAttr('name')

      form.attr('action', url)
      form[0].submit()
      false

    $('@search_line').autocomplete(source: @source).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li class="ul-menu-item"></li>').data('item.autocomplete', item).append('<img width="80" src=' + item.image + '>' + item.label).appendTo(ul)