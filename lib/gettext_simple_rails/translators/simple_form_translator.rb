class GettextSimpleRails::Translators::SimpleFormTranslator
  def detected?
    return ::Kernel.const_defined?("SimpleForm")
  end
  
  def translations
    return {}
  end
end
