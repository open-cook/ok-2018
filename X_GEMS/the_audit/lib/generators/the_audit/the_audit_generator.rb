class TheAuditGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  # argument :xname, type: :string, default: :xname

  # > rails g the_comments NAME
  def generate_controllers
    case gen_name
      when 'model'
        cp_model
      when 'controller'
        cp_controller
      when 'install'
        cp_model
        cp_controller
      else
        puts 'TheAudit Generator - wrong Name'
        puts 'Try to use [ install | controller | model ]'
    end
  end

  private

  def root_path; TheAudit::Engine.root; end

  def gen_name
    name.to_s.downcase
  end

  def cp_model
    copy_file "#{root_path}/app/models/_templates_/audit.rb",
              "app/models/audit.rb"
  end

  def cp_controller
    copy_file "#{root_path}/app/controllers/_templates_/audits_controller.rb",
              "app/controllers/admin/audits_controller.rb"
  end
end
