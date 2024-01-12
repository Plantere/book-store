class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, id: false, primary_key: :id do |t|
      t.string :id
      t.references :users, type: :string, index: true
      t.references :addresses, type: :string
      t.decimal :price, precision: 16, scale: 2
      t.text :description
      t.timestamps
    end
  end
  
  def down 
    drop_table :orders
  end
end
