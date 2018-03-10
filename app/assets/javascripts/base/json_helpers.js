/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
window.json2data = function(str, _default) {
  if (_default == null) { _default = []; }
  try {
    return JSON.parse(str);
  } catch (e) {
    log(str);
    log(`JSON parse error: ${ e }`);
    return _default;
  }
};

window.data2json = function(data, _default) {
  if (_default == null) { _default = '[]'; }
  try {
    return JSON.stringify(data);
  } catch (e) {
    log(data);
    log(`JSON stringify error: ${ e }`);
    return _default;
  }
};
