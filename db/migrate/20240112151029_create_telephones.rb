class CreateTelephones < ActiveRecord::Migration[7.1]
  def change
    create_table :telephones do |t|
      t.references :user, index: true, foreign_key: true
      t.string :phone_number, null: false
      t.string :area_code, null: false
      t.integer :ddi, null: false
      t.string :name, null: false
      t.timestamps
    end
  end

  def down 
    drop_table :telephones
  end
end
