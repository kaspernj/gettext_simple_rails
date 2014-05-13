class GettextSimpleRails::UserModelTranslations
  def self.attribute_translations
    puts _('models.attributes.role.id')
    puts _('models.attributes.role.role')
    puts _('models.attributes.role.user_id')
    puts _('models.attributes.role.created_at')
    puts _('models.attributes.role.updated_at')
  end

  def self.relationship_translations
    puts _('models.attributes.role.user')
  end

  def self.paperclip_attachments
  end

  def self.model_name
    puts _('models.name.role.one')
    puts _('models.name.role.other')
  end
end
