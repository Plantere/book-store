class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.references :author, index: true, foreign_key: true
      t.references :publisher, index: true, foreign_key: true
      t.references :genre, index: true, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :stock_quantity, null: false
      t.integer :status, :default => 1
      t.decimal :price, precision: 16, scale: 2, null: false
      t.timestamps
    end
    add_index :books, :name
  end

  def down
    drop_table :books
  end
end
