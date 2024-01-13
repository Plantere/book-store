class CreateOrderDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :order_details do |t|
      t.references :orders, index: true
      t.references :books, index: true
      t.integer :quantity
      t.decimal :price, precision: 16, scale: 2
      t.timestamps
    end
  end

  def down 
    drop_table :order_details
  end
end
