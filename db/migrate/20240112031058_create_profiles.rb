class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles, :id => false, :primary_key => :id  do |t|
      t.string :id
      t.string :user_id
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.string :avatar
      t.text :descritpion
      t.timestamps
    end

    add_index :profiles, :user_id, :unique => true
  end

  def down
    drop_table :profiles
  end
end
