import $ from 'jquery'
require('jquery-ujs')

require('@log_js-scripts/log_js')
require('@role_slim_js-scripts/jquery.data-role-selector')

import * as toastr from '@notifications-scripts/notifications/vendors/toastr'
window.toastr = toastr
require('@notifications-scripts/notifications')

require('../registration_accordion')
require('../login_popup')

require('@crop_tool-scripts/crop_tool/crop_tool')
require('@crop_tool-scripts/crop_tool/jcrop/jquery.Jcrop')
require('../avatar_crop')

require('@appJS/_open_cook/section-switcher')

require('./application_initializer')
