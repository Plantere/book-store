class CreatePublishers < ActiveRecord::Migration[7.1]
  def change
    create_table :publishers, id: false, primary_key: :id do |t|
      t.string :id
      t.string :name
      t.text :description
      t.timestamps
    end

    add_index(:publishers, :name, unique: true)
  end

  def down 
    drop_table :publishers
  end
end
