# RoleSlimJS

`data-role` for your frontend

1. https://github.com/ai/evil-blocks
2. https://github.com/kossnocorp/role

Gem provide

marker `@` for `data-role` for `SLIM`

```slim
@hello-world
  | Hello World
```

and JQ methods for `data-role`

```coffeescript
$ ->
  $('@hello-world').addRole 'sunshine'
  $('@hello-world').removeRole 'sunshine'
  $('@hello-world').toggleRole 'sunshine'
```

## DATA-ATTRIBUTES notice

`data-role` aka `@` for items with handlers or for items with values

for example

**SLIM**
```slim
button@btn-action
```

**JS (CoffeeScript)**
```coffeescript
$ ->
  $('@btn-action').on 'click', (e) ->
    # do something
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'role_slim_js'
```

And then execute:

```
bundle
```

## Usage

app/assets/javascripts/application.js

```
//= require jquery.data-role-selector
```

## MIT license
