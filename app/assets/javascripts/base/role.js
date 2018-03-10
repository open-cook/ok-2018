/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
window.by_role = name => $(`[data-role='${ name }']`);

// Add `@data-role` alias to jQuery.
// Copy from jquery.role by Sasha Koss https://github.com/kossnocorp/role

const rewriteSelector = function(context, name, pos) {
  const original = context[name];
  if (!original) { return; }
  context[name] = function() {
    arguments[pos] = arguments[pos].replace(/@@([\w\u00c0-\uFFFF\-]+)/g, "[data-block~=\"$1\"]");
    arguments[pos] = arguments[pos].replace(/@([\w\u00c0-\uFFFF\-]+)/g, "[data-role~=\"$1\"]");
    return original.apply(context, arguments);
  };

  $.extend(context[name], original);
};

rewriteSelector($, "find", 0);
rewriteSelector($, "multiFilter", 0);

rewriteSelector($.find, "matchesSelector", 1);
rewriteSelector($.find, "matches", 0);
