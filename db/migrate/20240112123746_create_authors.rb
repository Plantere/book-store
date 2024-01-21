class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :full_name, null: false
      t.date :birth_date, null: false
      t.text :biography
      t.timestamps
    end

    add_index :authors, [:full_name, :birth_date], unique: true
  end

  def down
    drop_table :authors
  end
end
