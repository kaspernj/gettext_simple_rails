class GettextSimpleRails::Translators::GlobalizeTranslator
  def detected?
    return ::Kernel.const_defined?("Globalize")
  end
  
  def translations
    @translations_hash = {
      "activerecord" => {
        "attributes" => {}
      }
    }
    attributes = @translations_hash["activerecord"]["attributes"]
    
    GettextSimpleRails::ModelInspector.model_classes do |inspector|
      next unless inspector.clazz.respond_to?(:globalize_migrator)
      
      class_lower_name = StringCases.camel_to_snake(inspector.clazz.name)
      translate_class_name = "#{inspector.clazz.name}::Translation"
      translate_class = translate_class_name.constantize
      
      id_column_name = "#{class_lower_name}_id"
      translate_columns = translate_class.column_names - ["id", "locale", "created_at", "updated_at", id_column_name]
      
      translate_columns.each do |column_name|
        attributes[class_lower_name] = {} unless attributes.key?(class_lower_name)
        attributes[class_lower_name][column_name] = column_name
      end
    end
    
    return @translations_hash
  end
end
