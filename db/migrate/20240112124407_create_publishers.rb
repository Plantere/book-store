class CreatePublishers < ActiveRecord::Migration[7.1]
  def change
    create_table :publishers do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end

    add_index(:publishers, :name, unique: true)
  end

  def down 
    drop_table :publishers
  end
end
