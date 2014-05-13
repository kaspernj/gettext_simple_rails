class GettextSimpleRails::SetupHelper
  def initialize(args)
    @args = args
  end
  
  def poedit_config_path
    if @args[:poedit_config_path]
      return @args[:poedit_config_path]
    else
      "#{ENV["HOME"]}/.poedit/config"
    end
  end
  
  def poedit_config_has_ruby_parser?
    config_content = File.read(poedit_config_path)
    return config_content.include?("[Parsers/Ruby]")
  end
  
  def poedit_add_ruby_parser_to_config
    sample_path = "#{File.dirname(__FILE__)}/../../config/poedit_ruby_parser.conf"
    sample_content = File.read(sample_path).strip
    config_content = File.read(poedit_config_path).strip
    
    File.open(poedit_config_path, "w") do |fp|
      fp.puts(config_content)
      fp.puts(sample_content)
    end
  end
  
  def poedit_config_has_ruby_in_list_of_parsers?
    config_content = File.read(poedit_config_path).strip
    parsers_list_match = config_content.match(/\[Parsers\]\s+List=(.+?)\n/)
    list = parsers_list_match[1].split(";")
    return list.include?("Ruby")
  end
  
  def poedit_config_add_ruby_to_list_of_parsers
    config_content = File.read(poedit_config_path).strip
    parsers_list_match = config_content.match(/\[Parsers\]\s+List=(.+?)\n/)
    list = parsers_list_match[1].split(";")
    list << "Ruby"
    
    new_config = config_content.gsub(parsers_list_match[0], "[Parsers]\nList=#{list.join(";")}\n")
    raise "Could not add Ruby to list of parsers." if new_config == config_content
    
    File.open(poedit_config_path, "w") do |fp|
      fp.puts(new_config)
    end
  end
end
