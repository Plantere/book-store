require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    let(:book) {create(:book)}

    it "should not be valid without presence of name" do
      book.name = nil
      expect(book).to_not be_valid  
    end


    it "should not be valid without presence of description" do
      book.description = nil
      expect(book).to_not be_valid  
    end

    it "should not be valid without presence of stock_quantity" do
      book.stock_quantity = nil
      expect(book).to_not be_valid  
    end


    it "should not be valid without presence of price" do
      book.price = nil
      expect(book).to_not be_valid  
    end

    it "should not be valid without presence of publisher_id" do
      book.publisher_id = nil
      expect(book).to_not be_valid  
    end

    it "should not be valid without presence of author_id" do
      book.author_id = nil
      expect(book).to_not be_valid  
    end

    it "should not be valid without presence of genre_id" do
      book.genre_id = nil
      expect(book).to_not be_valid  
    end

    it "should be valid with all values correct" do
      expect(book).to be_valid
    end

  end
end