require "spec_helper"
require "rake"
require "fileutils"

describe GettextSimpleRails::CacheHandler do
  before do
    ::Dummy::Application.load_tasks
  end
  
  it "should register when the cache is too old" do
    static_translation_file_path = "#{Rails.root}/config/locales_gettext/static_translation_file.json"
    File.unlink(static_translation_file_path) if File.exists?(static_translation_file_path)
    ::Rake::Task["gettext_simple_rails:generate_translator_files"].execute
    ::Rake::Task["gettext_simple_rails:generate_static_translation_file"].execute
    static_file_time = File.mtime(static_translation_file_path)
    
    cache_handler = GettextSimpleRails::CacheHandler.new
    time = File.mtime(cache_handler.newest_po_file)
    assert time < static_file_time
    cache_handler.cache_file_too_old?.should eq false
    
    sleep 1
    FileUtils.touch(cache_handler.newest_po_file)
    cache_handler.cache_file_too_old?.should eq true
  end
end
