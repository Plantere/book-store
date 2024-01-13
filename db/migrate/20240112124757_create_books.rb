class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.references :authors, index: true
      t.references :publishers, index: true
      t.string :name
      t.text :description
      t.integer :stock_quantity
      t.timestamps
    end
    add_index :books, :name
  end

  def down
    drop_table :books
  end
end
