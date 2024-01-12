class CreateBookImages < ActiveRecord::Migration[7.1]
  def change
    create_table :book_images, id: false, primary_key: :id do |t|
      t.string :id
      t.references :books, type: :string, index: true
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
