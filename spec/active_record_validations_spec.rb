require "spec_helper"

describe GettextSimpleRails::Translators::ActiveRecordValidationsTranslator do
  before do
    # Make it possible to call the Rake task.
    ::Dummy::Application.load_tasks

    # Clean up any existing translations.
    FileUtils.rm_r(GettextSimpleRails.translation_dir) if File.exists?(GettextSimpleRails.translation_dir)

    # Generate model translations so we can check them.
    ::Rake::Task["gettext_simple_rails:generate_translator_files"].execute
  end

  it "should generate translations for validations" do
    filepath = "#{GettextSimpleRails.translation_dir}/active_record_validations_translator_translations.rb"
    cont = File.read(filepath)
    cont.should include "_('activerecord.errors.models.user.attributes.name.too_short')"
    cont.should include "_('activerecord.errors.models.user.attributes.name.invalid')"
    cont.should include "_('activerecord.errors.models.user.attributes.name.blank')"
    cont.should include "_('activerecord.errors.models.user.attributes.name.taken')"
    cont.should include "_('activerecord.errors.models.user.attributes.name.invalid')"
    cont.should include "_('activerecord.errors.models.user.attributes.email.invalid')"
    cont.should include "_('activerecord.errors.models.user.attributes.base.restrict_dependent_destroy.many')"
  end
end
