@Select2 = do ->
  init: ->
    ts = $('@tags_input').first()

    if ts.length
      tags = ts.data('tags')

      ts.select2
        multiple: true
        tags: true
        data: tags.tags
        width: '100%'

    $('select.nested_options').select2
      width: '300px'
