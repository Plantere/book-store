class CreateTelephones < ActiveRecord::Migration[7.1]
  def change
    create_table :telephones, id: false, primary_key: :id do |t|
      t.string :id
      t.references :users, type: :string, index: true
      t.string :phone_number
      t.string :area_code
      t.string :name
      t.timestamps
    end
  end

  def down 
    drop_table :telephones
  end
end
