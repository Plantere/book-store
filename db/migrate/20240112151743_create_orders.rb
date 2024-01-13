class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :users, index: true
      t.references :addresses
      t.decimal :price, precision: 16, scale: 2
      t.text :description
      t.timestamps
    end
  end
  
  def down 
    drop_table :orders
  end
end
