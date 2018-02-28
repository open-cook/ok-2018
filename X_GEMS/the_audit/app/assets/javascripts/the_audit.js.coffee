@TheAudit = do ->
  init: ->
    do @init_controller_action_select
    do @init_datapickers

  init_datapickers: ->
    now = new Date
    plus_12  = new Date now.getFullYear(), (now.getMonth()+12), now.getDate()
    minus_12 = new Date now.getFullYear(), (now.getMonth()-12), now.getDate()

    $("[data-role='date_start'], [data-role='date_end']").datepicker
      minDate: minus_12,
      maxDate: plus_12
      dateFormat: 'yy-mm-dd'

  init_controller_action_select: ->
    $('@ctrl_acts select').on 'change', (e) ->
      select = $ e.target
      value = select.val()

      path = '?'
      path = "?controller_action=#{ $(e.target).val() }" if value.length
      location.href path
