# Installation

1. `git clone git@bitbucket.org:the_teacher/newopencook.git open-cook.ru`
2. `cd open-cook.ru`
3. `git clone git@github.com:DeployRB/DeployTool.git`
4. Copy files to

  * `DeployTool/__ENV__/production/*`
  * `DeployTool/__TEMPLATES__/production/*`

5. Copy SSH keys to `~/.ssh` && `chmod 400 YOUR_KEYS`
6. `cd DeployTool`
7. `bundle`
8. `DEPLOY_ENV=production ruby deploy.rb dump_db`
9. `DEPLOY_ENV=production ruby deploy.rb dump_files`
10. Copy and edit `cp config/config.examples/database.yml config/database.yml` file
10. `rake db:create`
11. POSTGRES: `pg_restore -h localhost -d open_cook_dev -U the-teacher ~/DUMPS/open-cook.ru.rails_app_db.2017_11_30_23_57.pq.sql`
12. Fill the `config/ENV/development/settings/main.yml` file

### Deploy Tool

* `DEPLOY_ENV=production ruby deploy.rb`
* `DEPLOY_ENV=production ruby deploy.rb dump_db`
* `DEPLOY_ENV=production ruby deploy.rb dump_files`

# Notes

### Social Networks Caching

* `tail -f -n 10 log/development.log | grep --line-buffered Cache`
* `https://developers.facebook.com/tools/debug/`
* `https://vk.com/dev/pages.clearCache`
