class CreateOrderDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :order_details, id: false, primary_key: :id do |t|
      t.string :id
      t.references :orders, type: :string, index: true
      t.references :books, type: :string, index: true
      t.integer :quantity
      t.decimal :price, precision: 16, scale: 2
      t.timestamps
    end
  end

  def down 
    drop_table :order_details
  end
end
