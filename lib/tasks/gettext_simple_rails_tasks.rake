namespace :gettext_simple_rails do
  task "generate_translator_files" => :environment do
    GettextSimpleRails::Translators.load_all.each do |translator_data|
      translator = translator_data[:class].new
      next unless translator.detected?
      
      translation_path = "#{GettextSimpleRails.translation_dir}/#{File.basename(translator_data[:file], ".rb")}_translations.rb"
      
      puts "Generating translation for #{translator.class.name} in #{translation_path}"
      
      FileUtils.mkdir_p(File.dirname(translation_path)) unless File.exists?(File.dirname(translation_path))
      
      File.open(translation_path, "w") do |fp|
        fp.puts "class GettextSimpleRails::MonthNames"
        fp.puts "  def translations"
        
        GettextSimpleRails.write_recursive_translations(fp, translator.translations)
        
        fp.puts "  end"
        fp.puts "end"
      end
    end
  end
  
  task "generate_model_translation_files" => :environment do
    GettextSimpleRails::ModelInspector.model_classes do |inspector|
      translation_path = "#{GettextSimpleRails.translation_dir}/models/#{inspector.snake_name}_model_translations.rb"
      FileUtils.mkdir_p(File.dirname(translation_path)) unless File.exists?(File.dirname(translation_path))
      
      File.open(translation_path, "w") do |fp|
        fp.puts "class GettextSimpleRails::UserModelTranslations"
        fp.puts "  def self.attribute_translations"
        
        inspector.attributes do |attribute|
          fp.puts "    puts _('#{attribute.gettext_key}')"
        end
        
        fp.puts "  end"
        
        fp.puts ""
        fp.puts "  def self.relationship_translations"
        
        inspector.relationships do |name, relationship|
          fp.puts "    puts _('#{inspector.relationship_gettext_key(name)}')"
        end
        
        fp.puts "  end"
        
        fp.puts ""
        fp.puts "  def self.paperclip_attachments"
        
        inspector.paperclip_attachments do |name|
          fp.puts "    puts _('#{inspector.relationship_gettext_key(name)}')"
        end
        
        fp.puts "  end"
        
        fp.puts ""
        fp.puts "  def self.model_name"
        fp.puts "    puts _('#{inspector.gettext_key}.one')"
        fp.puts "    puts _('#{inspector.gettext_key}.other')"
        fp.puts "  end"
        
        fp.puts "end"
      end
    end
  end
end