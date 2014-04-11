class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :role
      t.integer :user_id

      t.timestamps
    end
  end
end
