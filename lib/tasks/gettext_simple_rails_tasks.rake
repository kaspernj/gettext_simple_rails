namespace :gettext_simple_rails do
  task "all" => :environment do
    Rake::Task["gettext_simple_rails:generate_translator_files"].execute
  end

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

  task "create" => :environment do
    require "fileutils"
    I18n.available_locales.each do |locale|
      locales_gettext_path = "#{Rails.root}/config/locales_gettext"

      unless File.exist? locales_gettext_path
        puts "Creating locales-gettext directory in: #{locales_gettext_path}"
        Dir.mkdir(locales_gettext_path)
      end

      dir_path = "#{locales_gettext_path}/#{locale}/LC_MESSAGES"
      file_path = "#{dir_path}/default.po"

      if File.exists?(file_path)
        puts "Skipping #{locale} because a .po-file already exists in: #{file_path}"
        next
      end

      FileUtils.mkdir_p(dir_path) unless File.exists?(dir_path)

      project_name = Rails.application.class.parent_name

      content = File.read("#{File.dirname(__FILE__)}/../../config/default.po")
      content.gsub!("%{PROJECT_NAME}", project_name)
      content.gsub!("%{LOCALE}", locale.to_s)

      File.open(file_path, "w") do |fp|
        fp.write(content)
      end

      puts "Created default config for #{locale} in: #{file_path}"
    end
  end

  task "create_poedit_ruby_parser" do
    setup_helper = GettextSimpleRails::SetupHelper.new
    raise "POEdit config file could not be found in: #{setup_helper.poedit_config_path}" unless File.exists?(setup_helper.poedit_config_path)

    if setup_helper.poedit_config_has_ruby_parser?
      puts "Ruby parser already exists."
    else
      setup_helper.poedit_add_ruby_parser_to_config
      puts "Added Ruby-parser to config."
    end

    if setup_helper.poedit_config_has_ruby_in_list_of_parsers?
      puts "Ruby already in list of parsers."
    else
      setup_helper.poedit_config_add_ruby_to_list_of_parsers
      puts "Added Ruby to list of parsers."
    end
  end

  task "generate_static_translation_file" => :environment do
    cache_handler = GettextSimpleRails::CacheHandler.new
    cache_handler.write_static_translation_file

    puts "Static translation file saved in #{cache_handler.static_cache_file_path}"
  end
end
