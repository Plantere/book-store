class CreateBookImages < ActiveRecord::Migration[7.1]
  def change
    create_table :book_images do |t|
      t.references :books, index: true
      t.string :image_type
      t.string :image_path
      t.string :alt_text
      t.timestamps
    end
  end

  def down 
    drop_table :book_images
  end
end
