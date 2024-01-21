class CreateBookImages < ActiveRecord::Migration[7.1]
  def change
    create_table :book_images do |t|
      t.references :book, index: true, foreign_key: true
      t.string :image_type, null: false
      t.string :image_path, null: false
      t.string :alt_text, null: false
      t.timestamps
    end
  end

  def down 
    drop_table :book_images
  end
end
