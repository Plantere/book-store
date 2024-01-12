class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: false, primary_key: :id do |t|
      t.string :id
      t.string :username
      t.string :password
      t.string :email
      t.integer :status, :default =>  1
      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end

  def down
    drop_table :users
  end
end
