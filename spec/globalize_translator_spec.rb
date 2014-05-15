require "spec_helper"

describe GettextSimpleRails::Translators::GlobalizeTranslator do
  before do
    # Make it possible to call the Rake task.
    ::Dummy::Application.load_tasks
    
    # Clean up any existing translations.
    FileUtils.rm_r(GettextSimpleRails.translation_dir) if File.exists?(GettextSimpleRails.translation_dir)
    
    # Generate model translations so we can check them.
    ::Rake::Task["gettext_simple_rails:generate_translator_files"].execute
  end
  
  it "should generate translations for validations" do
    filepath = "#{GettextSimpleRails.translation_dir}/globalize_translator_translations.rb"
    cont = File.read(filepath)
    cont.should include "_('activerecord.attributes.user.title')"
  end
end
