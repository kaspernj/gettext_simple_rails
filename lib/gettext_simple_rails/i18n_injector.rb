class GettextSimpleRails::I18nInjector
  attr_reader :store_hash
  
  def initialize(args = {})
    @args = args
    @debug = args[:debug]
    @i18n_backend = I18n.config.backend
    @store_hash = {}
  end
  
  def inject_translator_translations(gettext_simple)
    @store_hash = {}
    
    GettextSimpleRails::Translators.load_all.each do |translator_data|
      translator = translator_data[:class].new
      next unless translator.detected?
      
      I18n.available_locales.each do |locale|
        next unless gettext_simple.locale_exists?(locale.to_s)
        locale = locale.to_s
        injector_recursive gettext_simple, locale, translator.translations
      end
    end
    
    @store_hash.each do |locale, language_hash|
      @i18n_backend.store_translations(locale.to_sym, language_hash)
    end
  end
  
  def inject_from_static_translation_file(args)
    translation_hash = JSON.parse(File.read(args[:path]))
    translation_hash.each do |locale, language_hash|
      @i18n_backend.store_translations(locale.to_sym, language_hash)
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
    @store_hash.deep_merge!({locale.to_sym => translation_hash})
  end
end
