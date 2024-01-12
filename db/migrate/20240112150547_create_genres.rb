class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres, id: false, primary_key: :id do |t|
      t.string :id
      t.string :name
      t.text :description
      t.timestamps
    end

    add_index :genres, :name, unique: true
  end
  
  def down 
    drop_table :genres
  end
end
