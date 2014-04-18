class GettextSimpleRails::Translators::DeviseTranslator
  def detected?
    return ::Kernel.const_defined?("Devise")
  end
  
  def translations
    return {}
  end
end
