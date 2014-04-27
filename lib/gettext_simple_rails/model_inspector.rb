class GettextSimpleRails::ModelInspector
  def self.model_classes(&blk)
    ::Rails.application.eager_load!
    @scanned = {}
    
    constants = Module.constants + Object.constants + Kernel.constants
    constants.each do |constant_name|
      model_classes_scan(Kernel, constant_name, &blk)
    end
  end
  
  # Tells if a class is an ActiveRecord model and handles errors.
  def self.active_record_status(clazz)
    begin
      return :yes if clazz < ActiveRecord::Base
    rescue NoMethodError, ArgumentError
      return :skip
    end
    
    return :no
  end
    
  def self.model_classes_scan(mod, constant_name, &blk)
    return if !mod.const_defined?(constant_name)
    
    begin
      clazz = mod.const_get(constant_name)
    rescue
      return
    end
    
    result = active_record_status(clazz)
    if result == :yes
      blk.call(::GettextSimpleRails::ModelInspector.new(clazz))
    elsif result == :skip
      return
    end
    
    clazz.constants.each do |class_sym|
      # Supresses a bit of the errors.½
      next if class_sym == :Fixtures || clazz.autoload?(class_sym)
      
      begin
        class_current = clazz.const_get(class_sym)
      rescue
        next
      rescue RuntimeError, LoadError
        next
      end
      
      next if !class_current.is_a?(Class) && !class_current.is_a?(Module)
      
      if @scanned[class_current]
        next
      else
        @scanned[class_current] = true
      end
      
      model_classes_scan(clazz, class_sym, &blk)
    end
  end
  
  attr_reader :clazz
  
  def initialize(clazz)
    @clazz = clazz
  end
  
  def attributes
    @clazz.attribute_names.each do |attribute_name|
      yield ::GettextSimpleRails::ModelInspector::Attribute.new(self, attribute_name)
    end
  end
  
  def paperclip_attachments
    if !::Kernel.const_defined?("Paperclip")
      return []
    end
    
    Paperclip::AttachmentRegistry.names_for(@clazz).each do |name|
      yield(name)
    end
  end
  
  def snake_name
    return ::StringCases.camel_to_snake(clazz.name)
  end
  
  def gettext_key
    return "models.name.#{snake_name}"
  end
  
  def gettext_key_one
    return "#{gettext_key}.one"
  end
  
  def gettext_key_other
    return "#{gettext_key}.other"
  end
  
  # TODO: Maybe this should yield a ModelInspector::Relationship instead?
  def relationships
    @clazz.reflections.each do |key, reflection|
      yield key, reflection
    end
  end
  
  def relationship_gettext_key(name)
    return "models.attributes.#{snake_name}.#{name}"
  end
  
  class Attribute
    attr_reader :name
    
    def initialize(clazz_inspector, name)
      @clazz_inspector = clazz_inspector
      @name = name
    end
    
    def gettext_key
      return "models.attributes.#{@clazz_inspector.snake_name}.#{@name}"
    end
  end
end
