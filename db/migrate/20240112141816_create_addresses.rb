class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, null: false
      t.string :country, null: false
      t.string :state, null: false
      t.string :street, null: false
      t.string :district, null: false
      t.string :city, null: false
      t.boolean :is_default, :default => false
      t.string :number, null: false
      t.string :complement
      t.string :phone_number
      t.string :postal_code, null: false
      t.timestamps
    end
  end
  def down 
    drop_table :addresses
  end
end
