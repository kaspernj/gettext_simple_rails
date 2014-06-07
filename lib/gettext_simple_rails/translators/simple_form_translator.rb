class GettextSimpleRails::Translators::SimpleFormTranslator
  def detected?
    return ::Kernel.const_defined?("SimpleForm")
  end
  
  def translations
    @translations = {"simple_form" => {
      "hints" => {},
      "placeholders" => {}
    }}
    
    hints = @translations["simple_form"]["hints"]
    placeholders = @translations["simple_form"]["placeholders"]
    
    GettextSimpleRails::ModelInspector.model_classes do |inspector|
      clazz_snake_name = StringCases.camel_to_snake(inspector.clazz.name)
      clazz_hints = {}
      
      hints[clazz_snake_name] = clazz_hints
      placeholders[clazz_snake_name] = clazz_hints
      
      inspector.attributes do |attribute|
        clazz_hints[attribute.name.to_s] = ""
      end
    end
    
    return @translations
  end
end
