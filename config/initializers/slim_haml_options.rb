if Rails.env.development?
  Haml::Template.options[:ugly] = false
  Slim::Engine.options[:pretty] = true
else
  Haml::Template.options[:ugly] = true
  Slim::Engine.options[:pretty] = false
end
