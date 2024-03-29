# TheComments.config.param_name => value

TheComments.configure do |config|
  config.max_reply_depth     = 6
  config.tolerance_time      = 5
  config.default_state       = :draft
  config.default_owner_state = :draft
  config.empty_inputs        = [:commentBody]
  config.default_title       = 'Undefined title'

  config.empty_trap_protection     = true
  config.tolerance_time_protection = true
end
