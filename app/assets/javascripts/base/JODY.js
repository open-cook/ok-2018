/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// render json: { flash: { alert: "Hello World!" } },       status: 422
// render json: { errors: { x: ["hello"], y: ["world"] } }, status: 422
// render json: { error: 'Error Message' },                 status: 422

window.JodyNotification = (() =>
  ({
    clean() {
      return $('div.toast').remove();
    },

    show_error(error) {
      return Notifications.show_error(error);
    },

    show_errors(errors) {
      return Notifications.show_errors(errors);
    },

    show_flash(flash) {
      return Notifications.show_flash(flash);
    },

    processor(data) {
      if (!(data != null ? data.keep_alerts : undefined)) { JodyNotification.clean(); }

      JodyNotification.show_errors(data.errors);
      JodyNotification.show_error(data.error);
      return JodyNotification.show_flash(data.flash);
    }
  })
)();

// Redirect processor
window.JodyRedirect = (function() {
  return {
    reload() { return (location.reload)(); },
    to(url) { return window.location.href  = url; },
    location_replace(url) { return window.location.replace(url); },

    exec(data) {
      let lurl, rurl;
      if (data.page_reload) { this.reload(); }
      if (rurl = data.redirect_to) { this.to(rurl); }
      if (lurl = data.location_replace) { return this.location_replace(lurl); }
    }
  };
})();

window.JodyHtml = (function() {
  return {
    processor(data) {
      this.html_content_replace(data);
      this.html_content_append(data);
      return this.change_attrs(data);
    },

    html_content_replace(data) {
      let selectors;
      if (selectors = __guard__(__guard__(data != null ? data.html_content : undefined, x1 => x1.replace), x => x.selectors)) {
        return (() => {
          const result = [];
          for (let selector in selectors) {
            const content = selectors[selector];
            result.push($(selector).html(content));
          }
          return result;
        })();
      }
    },

    html_content_append(data) {
      let selectors;
      if (selectors = __guard__(__guard__(data != null ? data.html_content : undefined, x1 => x1.append), x => x.selectors)) {
        return (() => {
          const result = [];
          for (let selector in selectors) {
            const content = selectors[selector];
            result.push($(selector).append(content));
          }
          return result;
        })();
      }
    },

    change_attrs(data) {
      // ADD
      let add_attrs, attr_name, attrs, delete_attrs, id, item, original_value, remove_attrs, replace_attrs, val;
      if (add_attrs = __guard__(__guard__(data != null ? data.html_content : undefined, x1 => x1.change_attrs), x => x.add)) {
        for (id in add_attrs) {
          attrs = add_attrs[id];
          if ((item = $(id)).length) {
            for (attr_name in attrs) {
              val = attrs[attr_name];
              original_value = item.attr(attr_name) || '';
              item.attr(attr_name, `${ original_value } ${ val }`);
            }
          }
        }
      }

      // REMOVE
      if (remove_attrs = __guard__(__guard__(data != null ? data.html_content : undefined, x3 => x3.change_attrs), x2 => x2.remove)) {
        for (id in remove_attrs) {
          attrs = remove_attrs[id];
          if ((item = $(id)).length) {
            for (attr_name in attrs) {
              val = attrs[attr_name];
              original_value = item.attr(attr_name) || '';
              item.attr(attr_name, original_value.replace(val, ''));
            }
          }
        }
      }

      // REPLACE
      if (replace_attrs = __guard__(__guard__(data != null ? data.html_content : undefined, x5 => x5.change_attrs), x4 => x4.replace)) {
        for (id in replace_attrs) {
          attrs = replace_attrs[id];
          if ((item = $(id)).length) {
            for (attr_name in attrs) {
              val = attrs[attr_name];
              item.attr(attr_name, val);
            }
          }
        }
      }

      // DELETE
      if (delete_attrs = __guard__(__guard__(data != null ? data.html_content : undefined, x7 => x7.change_attrs), x6 => x6.delete)) {
        return (() => {
          const result = [];
          for (id in delete_attrs) {
            attrs = delete_attrs[id];
            if ((item = $(id)).length) {
              result.push((() => {
                const result1 = [];
                for (attr_name in attrs) {
                  val = attrs[attr_name];
                  result1.push(item.removeAttr(attr_name));
                }
                return result1;
              })());
            } else {
              result.push(undefined);
            }
          }
          return result;
        })();
      }
    }
  };
})();

window.JodyJS = (function() {
  return {
    processor(data) {
      return this.js_functions_invoke(data);
    },

    js_functions_invoke(data) {
      let fus;
      if (fus = data != null ? data.js_function_invoke : undefined) {
        for (let fu in fus) {
          var _fu;
          const args = fus[fu];
          if (_fu = this.predefined_fu(fu)) {
            log(fu, args);
            _fu(args);
          }
        }
      }
      return true;
    },

    predefined_fu(fu_path) {
      let fu = window;
      fu_path = fu_path.split('.');

      for (let part of Array.from(fu_path)) {
        if (!fu[part]) { fu = null; break; }
        fu = fu[part];
      }
      return fu;
    }
  };
})();

// JODY: Json for dynamic sites
// Миддлвара, которая умеет разбирать приходящий JSON
// и делать кучу рутинной работы, вроде показа нотификаций
// и изменения кусков html
window.JODY = (function() {
  return {
    processor(data) {
      JodyNotification.processor(data);
      JodyHtml.processor(data);
      JodyRedirect.exec(data);
      return JodyJS.processor(data);
    },

    error_processor(xhr, response, status) {
      let _default, data;
      JodyNotification.clean();

      if (typeof (data = json2data(response.responseText, (_default = NaN))) === "object") {
        return JodyNotification.processor(data);
      } else {
        if ((response.status !== 0) && (response.status !== 200)) {
          return JodyNotification.show_error(`${ response.statusText }: ${ response.status }`);
        }
      }
    },

    // JODY/AJAX remote
    ajax_success(xhr, data, status, response) {
      JodyNotification.processor(data);
      JodyHtml.processor(data);
      JodyRedirect.exec(data);
      return JodyJS.processor(data);
    },

    ajax_error(xhr, response, status, message) {
      return this.error_processor(xhr, response, status);
    },

    remote_forms_init() {
      const JODY_forms = $('@JODY_form');

      JODY_forms.on('ajax:success', (xhr, data, status, response) => JODY.ajax_success(xhr, data, status, response));

      return JODY_forms.on('ajax:error', (xhr, response, status, message) => JODY.ajax_error(xhr, response, status, message));
    }
  };
})();

// @JodyModal = do ->
//   processor: (data) ->
//     if data?.modal?.hide is true
//       $('.modal').modal 'hide'

// @JodyForm = do ->
//   processor: (xhr, data, status) ->
//     return false unless (form = $ xhr.currentTarget).is('form')
//     do form[0].reset if data?.form?.reset is true

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
