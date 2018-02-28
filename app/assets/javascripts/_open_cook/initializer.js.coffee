@AppPreloader = (action = 'hide') ->
  return $('.app_preloader').show() if action is 'show'
  $('.app_preloader').hide()

$ ->
  do TopMenu.init
  do TopLink.init
  do TagSearch.init
  do SearchLine.init
  do Notifications.init
  do Notifications.show_notifications

  do SectionSwitcher.init
  do WelcomeIndexGrid.init

  # JODY FORMS
  do JODY.remote_forms_init

  # Comments
  $(document).on 'click', '.js-show_all_comments', ->
    $('.js-show_all_comments').addClass('hidden')
    $('.js-all_comments').removeClass('hidden')

  setTimeout ->
    do VK_Social_widgets.init
    do OK_Social_widgets.init
    do FB_Social_widgets.init
    do PIN_Social_widgets.init
    do TW_Social_widgets.init
  , 500
