class CreateTelephones < ActiveRecord::Migration[7.1]
  def change
    create_table :telephones do |t|
      t.references :user, index: true, foreign_key: true
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
