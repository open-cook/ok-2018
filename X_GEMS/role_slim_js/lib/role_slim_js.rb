require "role_slim_js/version"

module RoleSlimJS
  class Engine < ::Rails::Engine
    initializer 'role-slim-js.register' do
      if defined?(Slim::Parser)
        shortcut    = Slim::Parser.options[:shortcut]
        merge_attrs = Slim::Engine.options[:merge_attrs]

        shortcut.try :[]=, '@',  attr: 'data-role'
        merge_attrs.try :[]=, 'data-role',  ' '
      end
    end
  end
end
