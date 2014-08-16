class GettextSimpleRails::Translators::ActiveRecordValidationsTranslator
  def detected?
    ::Kernel.const_defined?("ActiveRecord")
  end

  def translations
    @translations_hash = {
      "activerecord" => {
        "errors" => {
          "messages" => {
            "record_invalid" => "Invalid record: %{errors}"
          },
          "models" => {}
        }
      }
    }

    scan_validation_errors
    scan_relation_errors

    return @translations_hash
  end

private

  def scan_validation_errors
    GettextSimpleRails::ModelInspector.model_classes do |inspector|
      clazz_snake_name = StringCases.camel_to_snake(inspector.clazz.name)
      @translations_hash["activerecord"]["errors"]["models"][clazz_snake_name] = {"attributes" => {}} unless @translations_hash["activerecord"]["errors"]["models"].key?(clazz_snake_name)
      attributes_hash = @translations_hash["activerecord"]["errors"]["models"][clazz_snake_name]["attributes"]

      inspector.clazz._validators.each do |attribute_name, validators|
        attribute_name = attribute_name.to_s

        validators.each do |validator|
          attributes_hash[attribute_name] = {} unless attributes_hash.key?(attribute_name)
          attribute_hash = attributes_hash[attribute_name]

          translations_for_length_validator(validator, attribute_hash) if validator.is_a?(ActiveModel::Validations::LengthValidator)
          translations_for_format_validator(validator, attribute_hash) if validator.is_a?(ActiveModel::Validations::FormatValidator)
          translations_for_uniqueness_validator(validator, attribute_hash) if validator.is_a?(ActiveRecord::Validations::UniquenessValidator)
          translations_for_presence_validator(validator, attribute_hash) if validator.is_a?(ActiveRecord::Validations::PresenceValidator)
          translations_for_email_validator(validator, attribute_hash) if validator.class.name == "EmailValidator"
        end
      end
    end
  end

  def scan_relation_errors
    GettextSimpleRails::ModelInspector.model_classes do |inspector|
      clazz_snake_name = StringCases.camel_to_snake(inspector.clazz.name)
      @translations_hash["activerecord"]["errors"]["models"][clazz_snake_name] = {"attributes" => {}} unless @translations_hash["activerecord"]["errors"]["models"].key?(clazz_snake_name)
      attributes_hash = @translations_hash["activerecord"]["errors"]["models"][clazz_snake_name]["attributes"]
      base_hash = attributes_hash["base"] ||= {}

      inspector.relationships do |name, reflection|
        if reflection.options[:dependent] == :restrict_with_error || reflection.options[:dependent] == :restrict_with_exception
          base_hash["restrict_dependent_destroy"] ||= {}

          if reflection.macro == :has_many
            base_hash["restrict_dependent_destroy"]["many"] ||= "Cannot delete record because dependent %{record} exist"
          elsif reflection.macro == :has_one
            base_hash["restrict_dependent_destroy"]["one"] ||= "Cannot delete record because a dependent %{record} exists"
          end
        end
      end
    end
  end

  def translations_for_length_validator(validator, attribute_hash)
    if validator.options[:minimum].present?
      attribute_hash["too_short"] = "is too short. The minimum is %{count}"
    end

    if validator.options[:maximum].present?
      attribute_hash["too_long"] = "is too long. The maximum is %{count}"
    end

    if validator.options[:is].present?
      attribute_hash["wrong_length"] = "is not the correct length: %{count}"
    end
  end

  def translations_for_format_validator(validator, attribute_hash)
    attribute_hash["invalid"] = "is invalid"
  end

  def translations_for_uniqueness_validator(validator, attribute_hash)
    attribute_hash["taken"] = "has already been taken"
  end

  def translations_for_presence_validator(validator, attribute_hash)
    attribute_hash["blank"] = "cannot be blank"
  end

  def translations_for_email_validator(validator, attribute_hash)
    attribute_hash["invalid"] = "is invalid"
  end
end
