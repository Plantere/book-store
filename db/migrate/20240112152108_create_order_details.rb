class CreateOrderDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :order_details do |t|
      t.references :order, index: true, foreign_key: true
      t.references :book, index: true, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :price, precision: 16, scale: 2, null: false
      t.timestamps
    end
  end

  def down 
    drop_table :order_details
  end
end
