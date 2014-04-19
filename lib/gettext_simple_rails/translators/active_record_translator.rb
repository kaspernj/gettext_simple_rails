class GettextSimpleRails::Translators::ActiveRecordTranslator
  def detected?
    true
  end
  
  def translations
    return {
      "activerecord" => {
        "errors" => {
          "messages" => {
            "record_invalid" => "Invalid record"
          }
        }
      }
    }
  end
end
