class GettextSimpleRails::I18nInjector
  def initialize(args = {})
    @debug = args[:debug]
  end
  
  def inject_model_translations(gettext_simple)
    i18n_backend = I18n.config.backend
    
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
        
        i18n_backend.store_translations(locale.to_sym, data)
      end
    end
  end
  
  def debug(str)
    $stderr.puts str if @debug
  end
end
