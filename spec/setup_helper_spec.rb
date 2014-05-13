require "spec_helper"

describe GettextSimpleRails::SetupHelper do
  it "should detect if a config doesnt contains ruby parser and ruby in the list and add them to the list" do
    tmp_config_path = "/tmp/poedit_config_file"
    sample_config_without_ruby = "#{File.dirname(__FILE__)}/poedit_config_without_ruby.conf"
    FileUtils.cp(sample_config_without_ruby, tmp_config_path)
    
    cache_handler = GettextSimpleRails::SetupHelper.new(
      :poedit_config_path => tmp_config_path
    )
    cache_handler.poedit_config_path.should eq tmp_config_path
    
    cache_handler.poedit_config_has_ruby_parser?.should eq false
    cache_handler.poedit_config_has_ruby_in_list_of_parsers?.should eq false
    
    cache_handler.poedit_add_ruby_parser_to_config
    
    cache_handler.poedit_config_has_ruby_parser?.should eq true
    cache_handler.poedit_config_has_ruby_in_list_of_parsers?.should eq false
    
    cache_handler.poedit_config_add_ruby_to_list_of_parsers
    
    cache_handler.poedit_config_has_ruby_parser?.should eq true
    cache_handler.poedit_config_has_ruby_in_list_of_parsers?.should eq true
  end
  
  it "should detect if a config already contains ruby parser and ruby in the list" do
    tmp_config_path = "/tmp/poedit_config_file"
    sample_config_with_ruby = "#{File.dirname(__FILE__)}/poedit_config_with_ruby.conf"
    FileUtils.cp(sample_config_with_ruby, tmp_config_path)
    
    cache_handler = GettextSimpleRails::SetupHelper.new(
      :poedit_config_path => tmp_config_path
    )
    cache_handler.poedit_config_path.should eq tmp_config_path
    
    cache_handler.poedit_config_has_ruby_parser?.should eq true
    cache_handler.poedit_config_has_ruby_in_list_of_parsers?.should eq true
  end
end
