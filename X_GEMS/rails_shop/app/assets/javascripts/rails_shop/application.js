import $ from 'jquery'
require('jquery-ujs')

require('@log_js-scripts/log_js')
require('@role_slim_js-scripts/jquery.data-role-selector')

import * as toastr from '@notifications-scripts/notifications/vendors/toastr'
window.toastr = toastr

require('@notifications-scripts/notifications')

require('@crop_tool-scripts/crop_tool/crop_tool')
require('@crop_tool-scripts/crop_tool/jcrop/jquery.Jcrop')

require('../vendors/custom_select/custom_select')

require('./main_image')
require('./products_edit')
require('./delivery_types')
require('./editable_block_switcher')
require('./order_payment_button')
require('./order_payment_form')

require('@user_room-scripts/user_room/registration_accordion')
require('@user_room-scripts/user_room/login_popup')
require('@appJS/_open_cook/section-switcher')

require('./application_initializer')
