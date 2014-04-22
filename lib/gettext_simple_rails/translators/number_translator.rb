class GettextSimpleRails::Translators::NumberTranslator
  def detected?
    true
  end
  
  def translations
    return {
      "number" => {
        "currency" => {
          "format" => {
            "delimiter" => ",",
            "format" => "%n %u",
            "separator" => ".",
            "unit" => "$"
          }
        },
        "format" => {
          "delimiter" => ",",
          "separator" => ".",
          
        },
        "human" => {
          "decimal_units" => {
            "format" => "%n %u",
            "units" => {
              "billion" => "Billion",
              "million" => "Million",
              "quadrillion" => "Quadrillion",
              "thousand" => "Thousand",
              "trillion" => "Trillion",
              "unit" => ""
            }
          },
          "format" => {
            "delimiter" => ""
          },
          "storage_units" => {
            "format" => "%n %u",
            "units" => {
              "byte" => {
                "one" => "Byte",
                "other" => "Bytes"
              },
              "gb" => "GB",
              "kb" => "KB",
              "mb" => "MB",
              "tb" => "TB"
            }
          }
        },
        "percentage" => {
          "format" => {
            "delimiter" => ""
          }
        }
      }
    }
  end
end
