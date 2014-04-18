class GettextSimpleRails::Translators::DateTranslator
  def detected?
    true
  end
  
  def translations
    return {
      "date" => {
        "formats" => {
          "default" => "%Y-%m-%d",
          "short" => "%b %d",
          "long" => "%B %d, %Y"
        },
        "day_names" => [0, 1, 2, 3, 4, 5, 6],
        "abbr_day_names" => [0, 1, 2, 3, 4, 5, 6],
        "month_names" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        "abbr_month_names" => [0 , 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
      },
      "time" => {
        "formats" => {
          "default" => "%a, %d %b %Y %H:%M:%S %z",
          "short" => "%d %b %H:%M",
          "long" => "%B %d, %Y %H:%M"
        },
        "am" => "am",
        "pm" => "pm"
      }
    }
  end
end
