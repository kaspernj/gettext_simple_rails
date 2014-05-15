class CreateUserTranslations < ActiveRecord::Migration
  def up
    User.create_translation_table!(
      :title => :string
    )
  end
  
  def down
    User.drop_translation_table!
  end
end
