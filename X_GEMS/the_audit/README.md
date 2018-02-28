# TheAudit - collect user's request info

### Простой, расширяемый
[#TODO clarify this sentence]

TheAudit - делает очень простую вещь - логгирует все базовые данные входящих запросов от пользователя и сохраняет эти данные в БД приложения. Предполагается использовать эти данные для мониторинга входящих запросов в приложение и в каждый отдельный контроллер/действие.

Work with Rails 4. This gem collects the following fields:
User, Obj, Controller/Action, IP,
Fullpath, Referer, User agent, 
Remote addr, Data.
[#TODO] clarify this fields and check in Rails 3 version

Администратор может просматривать все записи аудита, а так-же редактировать и удалять их. По ссылкам можно переходить на конкретные страницы просмотренные пользователем.

## GUI
<table>
<tr>
  <td>TheAudit management web interface => localhost:3000/admin/audits</td>
</tr>
<tr>
  <td><img src="https://github.com/the-teacher/the_audit/raw/master/pic.png" alt="TheAudit"></td>
</tr>
</table>

## Install
**Gemfile**
```ruby
gem "the_audit"

# You can use any Bootstrap 3 version (CSS, LESS, SCSS)
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'
```

```ruby
bundle
```
**Generators**

Show generator note
```
rails g the_audit --help
```

Run main generator
```
rails g the_audit install
```

This will create:
<pre>
   app/controllers/admin/audits_controller.rb
   app/models/audit.rb
</pre>

install TheAudit migration

```ruby
rake the_audit_engine:install:migrations
```

```ruby
rake db:migrate
```



Generated classes:

```ruby
class Admin::AuditsController < ApplicationController
  include TheAudit::Controller
end
```

```ruby
class Audit < ActiveRecord::Base
  include TheAudit::Base
end
```

```ruby
class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.integer :user_id

      t.string :obj_id
      t.string :obj_type

      t.string :controller_name
      t.string :action_name

      t.string :ip
      t.string :remote_ip
      t.string :fullpath
      t.string :referer
      t.string :user_agent
      t.string :remote_addr
      t.string :remote_host

      t.text :data

      # add_index :the_audits, :referer
      # add_index :the_audits, :user_agent
      # add_index :the_audits, [:controller_name, :action_name]

      t.timestamps
    end
  end
end
```

## Integration

#### Change controllers

Add to

**ApplicationController**
```ruby
class ApplicationController < ActionController::Base
  after_action :save_audit

  private
  def save_audit
    (@audit || Audit.new.init(self)).save unless controller_name == 'audits'
  end
end
```

**any audited controllers**
```ruby
class UsersController < ApplicationController  
  ...
  before_action :set_audit, only: %w[create show update edit destroy]
  
  def set_audit
    @audit = Audit.new.init(self, @user)
  end
end
```

#### GUI

Assets and Bootstrap

**application.css**

```
//= require bootstrap
```

**application.js**

```
//= require jquery
//= require jquery_ujs

//= require bootstrap
```

Change your layout

```ruby
= yield :the_audit_main
```

## Use

http://localhost:3000/admin/audits

## Locales
en, ru