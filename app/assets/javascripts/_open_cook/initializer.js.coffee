@AppPreloader = (action = 'hide') ->
  return $('.app_preloader').show() if action is 'show'
  $('.app_preloader').hide()

$ ->
  do window.TopMenu.init
  do window.TopLink.init
  do window.TagSearch.init
  do window.SearchLine.init
  do window.Notifications.init
  do window.Notifications.show_notifications

  do window.SectionSwitcher.init
  do window.WelcomeIndexGrid.init

  # JODY FORMS
  do JODY.remote_forms_init

  # Comments
  $(document).on 'click', '.js-show_all_comments', ->
    $('.js-show_all_comments').addClass('hidden')
    $('.js-all_comments').removeClass('hidden')

  setTimeout ->
    do window.VK_Social_widgets.init
    do window.OK_Social_widgets.init
    do window.FB_Social_widgets.init
    do window.PIN_Social_widgets.init
    do window.TW_Social_widgets.init
  , 500
