## Installation

1. `git clone git@github.com:open-cook/ok-2018.git open-cook.ru`
2. `cd open-cook.ru`
3. Copy and edit `cp config/config.examples/database.yml config/database.yml` file
4. Copy and edit `cp -r config/config.examples/ENV/ config/ENV`
5. `gem install bundler`
6. `bundle`
7. `rake db:create`

## Getting a recent data

1. `git clone git@github.com:DeployRB/DeployTool.git`
2. `cd DeployTool`
3. `bundle`
4. Copy files to `DeployTool/__ENV__/production/*`
5. Copy SSH keys to `~/.ssh` && `chmod 400 YOUR_KEYS`
6. `DEPLOY_ENV=production ruby deploy.rb dump_db`
7. `DEPLOY_ENV=production ruby deploy.rb dump_files`

## Notes

### Social Networks Caching

* `https://developers.facebook.com/tools/debug/`
* `https://vk.com/dev/pages.clearCache`

### Checking the logs

* `tail -f -n 10 log/development.log | grep --line-buffered Cache`
