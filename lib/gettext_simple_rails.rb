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
  
  def self.write_recursive_translations(fp, translations, pre_path = [], args = {})
    if translations.is_a?(Hash)
      translations.each do |key, val|
        newpath = pre_path + [key]
        write_recursive_translations(fp, val, newpath, :comment => "Default value: #{val}")
      end
    elsif translations.is_a?(Array)
      translations.each do |val|
        newpath = pre_path + [val]
        write_recursive_translations(fp, val, newpath)
      end
    elsif translations.is_a?(String) || translations.is_a?(Fixnum)
      if args[:comment]
        args[:comment].to_s.each_line do |line|
          fp.puts "    #. #{line}"
        end
      end
      
      fp.puts "    _('#{pre_path.join(".")}')"
    else
      raise "Unknownt class: '#{translations.class.name}'."
    end
  end
  
  def self.init
    require "gettext_simple"
    gettext_simple = GettextSimple.new(:i18n => true)
    gettext_simple.load_dir("#{Rails.root}/config/locales_gettext")
    gettext_simple.register_kernel_methods
    
    injector = GettextSimpleRails::I18nInjector.new
    cache_handler = GettextSimpleRails::CacheHandler.new
    
    if cache_handler.cache_file_too_old?
      puts "[GettextSimpleRails] Cache file too old - regenerating."
      cache_handler.write_static_translation_file
    end
    
    puts "[GettextSimpleRails] Injecting translations from cache."
    injector.inject_from_static_translation_file(:path => cache_handler.static_cache_file_path)
  end
  
  class Translators
    def self.const_missing(name)
      require "#{::File.dirname(__FILE__)}/gettext_simple_rails/translators/#{::StringCases.camel_to_snake(name)}"
      raise LoadError, "Still not loaded: '#{name}'." unless ::GettextSimpleRails::Translators.const_defined?(name)
      return ::GettextSimpleRails::Translators.const_get(name)
    end
    
    def self.load_all
      result = []
      
      path = "#{File.dirname(__FILE__)}/gettext_simple_rails/translators"
      Dir.foreach(path) do |file|
        next unless match = file.match(/^(.+_translator)\.rb$/)
        require "#{path}/#{file}"
        
        class_name = StringCases.snake_to_camel(match[1])
        clazz = ::GettextSimpleRails::Translators.const_get(class_name)
        
        result << {
          :path => path,
          :file => file,
          :class => clazz
        }
      end
      
      return result
    end
  end
end
