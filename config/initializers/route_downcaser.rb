RouteDowncaser.configuration do |config|
  config.redirect = true

  config.exclude_patterns = [
    /assets\//i,
    /fonts\//i,
    /rails\/mailers\//i
  ]
end