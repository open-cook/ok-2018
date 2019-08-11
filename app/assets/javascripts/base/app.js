/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// import '@jquery'

window.App = (() =>
  ({
    env: (function() {
      return {
        _env() {
          let env;
          if (env = window.APP_ENV) { return env; }
          return window.APP_ENV = __guard__(__guard__(__guard__(document.getElementById('env_token'), x2 => x2.attributes), x1 => x1.content), x => x.value);
        },

        name(env) { if (env == null) { env = 'undefined_env'; } return this._env() === env; },
        development() { return this.name('development'); },
        production() { return this.name('production'); },
        staging() { return this.name('staging'); }
      };
    })()
  })
)();

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
