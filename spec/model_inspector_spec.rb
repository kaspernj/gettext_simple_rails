require "spec_helper"

# Some subclasses the modelinspector should find later in the specs.
class SomeClass
  class SomeSubClass < ActiveRecord::Base
  end
end

module SomeModule
  class SomeSubClassOfModule < ActiveRecord::Base
  end
end


describe GettextSimpleRails::ModelInspector do
  it "should register subclasses" do
    found_sub_class = false
    found_sub_class_of_module = false
    
    GettextSimpleRails::ModelInspector.model_classes do |inspector|
      if inspector.clazz.name == "SomeClass::SomeSubClass"
        found_sub_class = true
      elsif inspector.clazz.name == "SomeModule::SomeSubClassOfModule"
        found_sub_class_of_module = true
      end
    end
    
    found_sub_class.should eq true
    found_sub_class_of_module.should eq true
  end
end
