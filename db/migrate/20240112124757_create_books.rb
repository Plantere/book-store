class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books, id: false, primary_key: :id do |t|
      t.string :id
      t.references :authors, type: :string, index: true
      t.references :publishers, type: :string, index: true
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
