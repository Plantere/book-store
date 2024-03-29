class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles  do |t|
      t.references :user, index: true, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :birth_date
      t.string :avatar
      t.text :description
      t.timestamps
    end
  end

  def down
    drop_table :profiles
  end
end
