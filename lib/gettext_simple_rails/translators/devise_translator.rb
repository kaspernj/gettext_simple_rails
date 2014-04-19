class GettextSimpleRails::Translators::DeviseTranslator
  def detected?
    return ::Kernel.const_defined?("Devise")
  end
  
  def translations
    devise_gem_path = Gem.loaded_specs['devise'].full_gem_path
    devise_yml_translation_file = "#{devise_gem_path}/config/locales/en.yml"
    translations = YAML.load(File.read(devise_yml_translation_file))
    
    # Add failure translations for all devise models.
    devise_models.each do |clazz|
      translations["en"]["devise"]["failure"][StringCases.camel_to_snake(clazz.name)] = translations["en"]["devise"]["failure"].clone
    end
    
    return translations["en"]
  end
  
private
  
  def devise_models
    classes = []
    
    ::Rails.application.eager_load!
    
    ::Object.constants.each do |clazz|
      clazz = clazz.to_s.constantize
      next unless clazz.class == Class
      next unless clazz < ActiveRecord::Base
      next unless clazz.respond_to?(:devise_modules)
      classes << clazz
    end
    
    return classes
  end
end
