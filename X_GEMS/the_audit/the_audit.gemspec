# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_audit/version'

Gem::Specification.new do |gem|
  gem.name          = "the_audit"
  gem.version       = TheAudit::VERSION
  gem.authors       = ["Ilya N. Zykin"]
  gem.email         = ["zykin-ilya@ya.ru"]
  gem.description   = %q{Collect basic request info in Rails app}
  gem.summary       = %q{Collect basic request info in Rails app}
  gem.homepage      = "https://github.com/the-teacher"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'haml'
end
