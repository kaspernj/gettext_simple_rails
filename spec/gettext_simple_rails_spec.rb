require 'spec_helper'
require 'rake'

describe GettextSimpleRails do
  before do
    # Make it possible to call the Rake task.
    ::Dummy::Application.load_tasks
    
    # Clean up any existing translations.
    FileUtils.rm_r(GettextSimpleRails.translation_dir) if File.exists?(GettextSimpleRails.translation_dir)
    
    # Generate model translations so we can check them.
    ::Rake::Task["gettext_simple_rails:generate_translator_files"].execute
  end
  
  it "generates model translations" do
    user_model_translations_path = "#{GettextSimpleRails.translation_dir}/active_record_attributes_translator_translations.rb"
    assert File.exists?(user_model_translations_path), "a file with user model translations should have been created but wasn't."
    content = File.read(user_model_translations_path)
    
    content.should include "_('activerecord.models.user.one')"
    content.should include "_('activerecord.models.user.other')"
    
    attributes = ["id", "name", "birthday_at", "age", "created_at", "updated_at"]
    attributes.each do |attribute|
      content.should include "_('activerecord.attributes.user.#{attribute}')"
    end
    
    # Relationship translations.
    assert content.include?("_('activerecord.attributes.user.roles')"), "didn't contain relationship translations"
  end
  
  it "can inject the translations into I18n" do
    require "gettext_simple"
    gs = GettextSimple.new
    locales = gs.instance_variable_get(:@locales)
    locales["da"] = {}
    locales["en"] = {}
    
    gs.__send__(:add_translation, "da", "activerecord.models.user.one", "Bruger")
    gs.__send__(:add_translation, "da", "activerecord.models.user.other", "Brugere")
    gs.__send__(:add_translation, "da", "activerecord.attributes.user.name", "Navn")
    
    injector = GettextSimpleRails::I18nInjector.new
    injector.inject_translator_translations(gs)
    
    I18n.with_locale :da do
      assert_equal "Bruger", I18n.t("activerecord.models.user.one")
      assert_equal "Brugere", I18n.t("activerecord.models.user.other")
      assert_equal "Navn", I18n.t("activerecord.attributes.user.name")
    end
  end
end
