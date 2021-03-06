class GettextSimpleRails::MonthNames
  def translations
    #. Default value: Invalid record: %{errors}
    _('activerecord.errors.messages.record_invalid')
    #. Default value: is too short. The minimum is %{count}
    _('activerecord.errors.models.user.attributes.name.too_short')
    #. Default value: is too long. The maximum is %{count}
    _('activerecord.errors.models.user.attributes.name.too_long')
    #. Default value: has already been taken
    _('activerecord.errors.models.user.attributes.name.taken')
    #. Default value: cannot be blank
    _('activerecord.errors.models.user.attributes.name.blank')
    #. Default value: is invalid
    _('activerecord.errors.models.user.attributes.name.invalid')
    #. Default value: is invalid
    _('activerecord.errors.models.user.attributes.email.invalid')
    #. Default value: Cannot delete record because dependent %{record} exist
    _('activerecord.errors.models.user.attributes.base.restrict_dependent_destroy.many')
  end
end
