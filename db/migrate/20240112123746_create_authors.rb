class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors, id: false, primary_key: :id do |t|
      t.string :id
      t.string :full_name
      t.date :birth_date
      t.text :biography
      t.timestamps
    end

    add_index :authors, [:full_name, :birth_date], unique: true
  end

  def down
    drop_table :authors
  end
end