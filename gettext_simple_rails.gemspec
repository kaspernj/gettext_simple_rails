$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gettext_simple_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gettext_simple_rails"
  s.version     = GettextSimpleRails::VERSION
  s.authors     = ["Kasper Johansen"]
  s.email       = ["k@spernj.org"]
  s.homepage    = "http://www.github.com/kaspernj/gettext_simple_rails"
  s.summary     = "Helpers for translating a Rails app with Gettext and POEdit."
  s.description = "Inspects models and other modules to easily generate .po-files and translate them with POEdit."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency "gettext_simple", ">= 0.0.9"
  s.add_dependency "string-cases"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "email_validator"
  s.add_development_dependency "forgery"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "globalize", "~> 4.0.1"
  s.add_development_dependency "codeclimate-test-reporter"
end
