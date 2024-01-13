class AddGenresReferenceToBooks < ActiveRecord::Migration[7.1]
  def change
    change_table :books do |t|
      t.references :genre, index: true, foreign_key: true
    end
  end
end
