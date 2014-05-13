class GettextSimpleRails::I18nInjector
  attr_reader :store_hash
  
  def initialize(args = {})
    @args = args
    @debug = args[:debug]
    @i18n_backend = I18n.config.backend
    @store_hash = {} if args[:store_in_hash]
  end
  
  def inject_translator_translations(gettext_simple)
    @translator_translations = {}
    
    GettextSimpleRails::Translators.load_all.each do |translator_data|
      translator = translator_data[:class].new
      next unless translator.detected?
      
      I18n.available_locales.each do |locale|
        next unless gettext_simple.locale_exists?(locale.to_s)
        locale = locale.to_s
        injector_recursive gettext_simple, locale, translator.translations
      end
    end
  end
  
  def inject_model_translations(gettext_simple)
    GettextSimpleRails::ModelInspector.model_classes do |inspector|
      model = {}
      attributes = {}
      
      data = {
        "activerecord" => {
          "models" => {
            inspector.snake_name => model
          },
          "attributes" => {
            inspector.snake_name => attributes
          }
        }
      }
      
      I18n.available_locales.each do |locale|
        locale = locale.to_s
        
        unless gettext_simple.locale_exists?(locale)
          debug "Skipping locale because it hasn't been loaded into GettextSimple: #{locale}" if @debug
          next
        end
        
        debug "Loading locale: #{locale}" if @debug
        
        one_translation = gettext_simple.translate_with_locale(locale, inspector.gettext_key_one)
        if one_translation != inspector.gettext_key_one
          model["one"] = one_translation
        end
        
        other_translation = gettext_simple.translate_with_locale(locale, inspector.gettext_key_other)
        if other_translation != inspector.gettext_key_other
          model["other"] = other_translation
        end
        
        inspector.attributes do |attribute|
          attribute_translation = gettext_simple.translate_with_locale(locale, attribute.gettext_key)
          if attribute_translation != attribute.gettext_key
            debug "Translating #{inspector.snake_name}.#{attribute.name} to #{attribute_translation}" if @debug
            attributes[attribute.name.to_s] = attribute_translation
          else
            debug "Skipping #{inspector.snake_name}.#{attribute.name}" if @debug
          end
        end
        
        inspector.relationships do |name, reflection|
          relationship_translation = gettext_simple.translate_with_locale(locale, inspector.relationship_gettext_key(name))
          if relationship_translation != inspector.relationship_gettext_key(name)
            attributes[name.to_s] = relationship_translation
          end
        end
        
        store_translations(locale, data)
      end
    end
  end
  
  def inject_from_static_translation_file(args)
    translation_hash = JSON.parse(File.read(args[:path]))
    translation_hash.each do |locale, language_hash|
      store_translations(locale, language_hash)
    end
  end
  
private
  
  def debug(str)
    $stderr.puts str if @debug
  end
  
  def injector_recursive(gettext_simple, locale, translations, pre_path = [])
    if translations.is_a?(Hash)
      translations.each do |key, val|
        newpath = pre_path + [key]
        injector_recursive(gettext_simple, locale, val, newpath)
      end
    elsif translations.is_a?(Array)
      injector_recursive_array(gettext_simple, locale, translations, pre_path)
    elsif translations.is_a?(String)
      gettext_key = "#{pre_path.join(".")}"
      translation = gettext_simple.translate_with_locale(locale.to_s, gettext_key)
      
      if !translation.to_s.empty? && translation != gettext_key
        translation_hash = {}
        translation_current = translation_hash
        pre_path.each_with_index do |path, index|
          if index == (pre_path.length - 1)
            translation_current[path] = translation
          else
            translation_current[path] = {}
            translation_current = translation_current[path]
          end
        end
        
        store_translations(locale, translation_hash)
      end
    else
      raise "Unknown class: '#{translations.class.name}'."
    end
  end
  
  def injector_recursive_array(gettext_simple, locale, translations, pre_path = [])
    translation_array = []
    translations.each_with_index do |val, index|
      gettext_key = "#{pre_path.join(".")}.#{index}"
      translation = gettext_simple.translate_with_locale(locale.to_s, gettext_key)
      next if translation.to_s.empty? || translation == gettext_key
      translation_array << translation
    end
    
    translation_hash = {}
    translation_current = translation_hash
    pre_path.each_with_index do |path, index|
      if index == (pre_path.length - 1)
        translation_current[path] = translation_array
      else
        translation_current[path] = {}
        translation_current = translation_current[path]
      end
    end
    
    store_translations(locale, translation_hash)
  end
  
  def store_translations(locale, translation_hash)
    if @args[:store_in_hash]
      @store_hash.deep_merge!({locale.to_sym => translation_hash})
    else
      @i18n_backend.store_translations(locale.to_sym, translation_hash)
    end
  end
end
