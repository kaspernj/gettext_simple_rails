require "gettext_simple_rails/engine"
require "string-cases"

module GettextSimpleRails
  def self.const_missing(name)
    require "#{::File.dirname(__FILE__)}/gettext_simple_rails/#{::StringCases.camel_to_snake(name)}"
    raise LoadError, "Still not loaded: '#{name}'." unless ::GettextSimpleRails.const_defined?(name)
    return ::GettextSimpleRails.const_get(name)
  end
  
  def self.translation_dir
    return "#{Rails.root}/lib/gettext_simple_rails"
  end
end
