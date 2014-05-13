require "spec_helper"

describe GettextSimpleRails::Translators::DateTranslator do
  before do
    # Make it possible to call the Rake task.
    ::Dummy::Application.load_tasks
    
    # Clean up any existing translations.
    FileUtils.rm_r(GettextSimpleRails.translation_dir) if File.exists?(GettextSimpleRails.translation_dir)
    
    # Generate model translations so we can check them.
    ::Rake::Task["gettext_simple_rails:generate_translator_files"].execute
  end
  
  it "generates month names translations" do
    filepath = "#{GettextSimpleRails.translation_dir}/date_translator_translations.rb"
    cont = File.read(filepath)
    cont.should include "_('date.day_names.6')"
  end
end
