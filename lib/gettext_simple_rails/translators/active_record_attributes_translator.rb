class GettextSimpleRails::Translators::ActiveRecordAttributesTranslator
  def detected?
    ::Kernel.const_defined?("ActiveRecord")
  end
  
  def translations
    @translations_hash = {
      "activerecord" => {
        "attributes" => {},
        "models" => {}
      }
    }
    attributes_hash = @translations_hash["activerecord"]["attributes"]
    models_hash = @translations_hash["activerecord"]["models"]
    
    GettextSimpleRails::ModelInspector.model_classes do |inspector|
      lower_class_name = StringCases.camel_to_snake(inspector.clazz.name)
      models_hash[lower_class_name] = {
        "one" => inspector.clazz.name,
        "other" => inspector.clazz.name
      }
      attributes_hash[lower_class_name] = {} unless attributes_hash.key?(lower_class_name)
      attributes = attributes_hash[lower_class_name]
      
      inspector.attributes do |attribute|
        attributes[attribute.name.to_s] = attribute.name.to_s
      end
      
      inspector.relationships do |name, reflection|
        attributes[name.to_s] = name.to_s
      end
    end
    
    return @translations_hash
  end
end
