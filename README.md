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

## Becoming a deployer

1. [How to generate a new ssh key Manual](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key)
2. `mkdir -p ~/.ssh/ && cd ~/.ssh`
3. `ssh-keygen -f OpenCookDeployer -t rsa -b 4096 -C "deployer@open-cook.ru"`
4. `cat ~/.ssh/OpenCookDeployer.pub | ssh rails@open-cook.ru 'cat > ~/.ssh/authorized_keys'` **User a password**
5. `cat ~/.ssh/OpenCookDeployer.pub | ssh root@open-cook.ru 'cat > ~/.ssh/authorized_keys'` **User a password**
6. `ssh rails@open-cook.ru -i ~/.ssh/OpenCookDeployer`
7. `ssh root@open-cook.ru -i ~/.ssh/OpenCookDeployer`
8. Add deployer keys at Github.com `https://github.com/open-cook/ok-2018/settings/keys/new`

## Notes

### Social Networks Caching

* `https://developers.facebook.com/tools/debug/`
* `https://vk.com/dev/pages.clearCache`

### Checking the logs

* `tail -f -n 10 log/development.log | grep --line-buffered Cache`
