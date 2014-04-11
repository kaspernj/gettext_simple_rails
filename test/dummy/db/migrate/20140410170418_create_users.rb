class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.date :birthday_at
      t.integer :age

      t.timestamps
    end
  end
end
