class GettextSimpleRails::UserModelTranslations
  def self.attribute_translations
    puts _('models.attributes.user.id')
    puts _('models.attributes.user.name')
    puts _('models.attributes.user.birthday_at')
    puts _('models.attributes.user.age')
    puts _('models.attributes.user.created_at')
    puts _('models.attributes.user.updated_at')
  end

  def self.relationship_translations
    puts _('models.attributes.user.roles')
  end

  def self.paperclip_attachments
  end

  def self.model_name
    puts _('models.name.user.one')
    puts _('models.name.user.other')
  end
end
