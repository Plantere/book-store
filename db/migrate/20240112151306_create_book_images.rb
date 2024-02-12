class CreateBookImages < ActiveRecord::Migration[7.1]
  def change
    create_table :book_images do |t|
      t.references :book, index: true, foreign_key: true
      t.string :path, null: false
      t.boolean :is_default, default: false
      t.string :token_image, null: false
      t.timestamps
    end
  end

  def down 
    drop_table :book_images
  end
end
