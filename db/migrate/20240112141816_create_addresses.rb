class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses, id: false, primary_key: :id do |t|
      t.string :id
      t.references :users, type: :string, index: true
      t.string :name
      t.string :country
      t.string :state
      t.string :district
      t.string :number
      t.string :complement
      t.string :postal_code
      t.timestamps
    end
  end
  def down 
    drop_table :addresses
  end
end
