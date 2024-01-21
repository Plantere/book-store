class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.references :address, index: true, foreign_key: true
      t.decimal :price, precision: 16, scale: 2, null: false
      t.text :description
      t.timestamps
    end
  end
  
  def down 
    drop_table :orders
  end
end
