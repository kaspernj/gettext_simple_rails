class GettextSimpleRails::Translators::ActiveAdminTranslator
  def detected?
    return ::Kernel.const_defined?("ActiveAdmin")
  end
  
  def translations
    result = {
      "active_admin" => {
        "globalize" => {
          "language" => {},
          "translations" => ""
        }
      }
    }
    
    I18n.available_locales.each do |locale|
      result["active_admin"]["globalize"]["language"][locale.to_s] = locale.to_s
    end
    
    return result
  end
end
