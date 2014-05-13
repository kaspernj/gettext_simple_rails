class GettextSimpleRails::CacheHandler
  def newest_po_file
    newest_time = nil
    newest_path = nil
    
    I18n.available_locales.each do |locale|
      default_path_file = "#{Rails.root}/config/locales_gettext/#{locale}/LC_MESSAGES/default.po"
      next unless File.exists?(default_path_file)
      time = File.mtime(default_path_file)
      newest_time = time if newest_time == nil || time > newest_time
      newest_path = default_path_file
    end
    
    return newest_path
  end
  
  def static_cache_file_path
    "#{Rails.root}/config/locales_gettext/static_translation_file.json"
  end
  
  def cache_file_too_old?
    if !File.exists?(static_cache_file_path)
      return true
    elsif File.mtime(static_cache_file_path) < File.mtime(newest_po_file)
      return true
    else
      return false
    end
  end
  
  def write_static_translation_file
    require "gettext_simple"
    gs = GettextSimple.new(:i18n => true)
    gs.load_dir("#{Rails.root}/config/locales_gettext")
    gs.register_kernel_methods
    
    injector = GettextSimpleRails::I18nInjector.new(:store_in_hash => true)
    injector.inject_model_translations(gs)
    injector.inject_translator_translations(gs)
    
    File.open(static_cache_file_path, "w") do |fp|
      fp.write(injector.store_hash.to_json)
    end
  end
end
