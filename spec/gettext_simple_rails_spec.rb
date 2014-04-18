require 'spec_helper'
require 'rake'

describe GettextSimpleRails do
  before do
    if !$translations_generated
      $translations_generated = true
      
      # Make it possible to call the Rake task.
      ::Dummy::Application.load_tasks
      
      # Clean up any existing translations.
      FileUtils.rm_r(GettextSimpleRails.translation_dir) if File.exists?(GettextSimpleRails.translation_dir)
      
      # Generate model translations so we can check them.
      ::Rake::Task["gettext_simple_rails:generate_model_translation_files"].invoke
    end
  end
  
  it "generates model translations" do
    user_model_translations_path = "#{GettextSimpleRails.translation_dir}/models/user_model_translations.rb"
    assert File.exists?(user_model_translations_path), "a file with user model translations should have been created but wasn't."
    content = File.read(user_model_translations_path)
    
    assert content.include?("puts _('models.name.user.one')"), "should include model name"
    assert content.include?("puts _('models.name.user.other')"), "should include model name"
    
    attributes = ["id", "name", "birthday_at", "age", "created_at", "updated_at"]
    attributes.each do |attribute|
      assert content.include?("puts _('models.attributes.user.#{attribute}')"), "should include attribute #{attribute}"
    end
    
    # Relationship translations.
    assert content.include?("puts _('models.attributes.user.roles')"), "didn't contain relationship translations"
  end
  
  it "can inject the translations into I18n" do
    require "gettext_simple"
    gs = GettextSimple.new
    locales = gs.instance_variable_get(:@locales)
    locales["da"] = {}
    locales["en"] = {}
    
    gs.__send__(:add_translation, "da", "models.name.user.one", "Bruger")
    gs.__send__(:add_translation, "da", "models.name.user.other", "Brugere")
    
    gs.__send__(:add_translation, "da", "models.attributes.user.name", "Navn")
    
    injector = GettextSimpleRails::I18nInjector.new
    injector.inject_model_translations(gs)
    
    I18n.with_locale :da do
      assert_equal "Bruger", I18n.t("activerecord.models.user.one")
      assert_equal "Brugere", I18n.t("activerecord.models.user.other")
      assert_equal "Navn", I18n.t("activerecord.attributes.user.name")
    end
  end
end
