class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
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
