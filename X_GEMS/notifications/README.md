## Notifications

Just add JSON on HTML notifications in your APP

Designed for Bootstrap 3 style of for toastr notifications

## How it works

Just remove

```ruby
<%= form_for(@resource) do |f| %>
  <% if @resource.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@resource.errors.count, "error") %> prohibited this resource from being saved:</h2>

      <ul>
      <% @resource.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  # ....

<% end %>
```

with

```ruby
<%= form_for(@post) do |f| %>
  <%= render partial: 'notifications/form', locals: { object: @post } %>

  # ....

<% end %>
```

and add to Layout

```ruby
<body>
  <%= render partial: 'notifications/flash' %>
  <%= yield %>
```

*application.css*
```js
*= require bootstrap
*= require notifications/vendors/toastr
```

*application.js*
```js
//= require notifications/vendors/toastr
//= require notifications

$ ->
  Notifications.init()
  Notifications.show_notifications()
```

### HTML or JSON

```erb
<%= render partial: 'notifications/flash', locals: { format: :html } %>
<%= render partial: 'notifications/form', locals: { object: @post, format: :html } %>
```

or

```erb
<%= render partial: 'notifications/flash', locals: { format: :json } %>
<%= render partial: 'notifications/form', locals: { object: @post, format: :json } %>
```

*initializers/notifications.rb*
```ruby
Notifications.configure do |config|
  config.default_type = :json # :html
end
```

### Localized errors

*models/user.rb*
```ruby
class Post < ActiveRecord::Base
  include Notifications::LocalizedErrors
end
```

*config/locales/ru.yml*
```
activerecord:
  models:
    post: Публикация
  attributes:
    post:
      title: "Загловок"
```

Now errors messages will looks like this:

```
Загловок: не может быть пустым
```

instead

```
Title: не может быть пустым
```

### Installation

```ruby
gem 'notifications'
```

```sh
$ bundle
```

### Usage

TODO: Write usage instructions here
