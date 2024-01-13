class AddGenresReferenceToBooks < ActiveRecord::Migration[7.1]
  def change
    change_table :books do |t|
      t.references :genres, index: true    
    end
  end
end
