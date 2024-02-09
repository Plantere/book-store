require 'rails_helper'

RSpec.describe BookImage, type: :model do
  describe 'validations' do
    let(:book_image) {create(:book_image)}

    it "should not be valid without presence of path" do
      book_image.path = nil
      expect(book_image).to_not be_valid  
    end

    it "should not be valid without presence of is_default" do
      book_image.is_default = nil
      expect(book_image).to_not be_valid  
    end

    it "should not be valid without presence of book_id" do
      book_image.book_id = nil
      expect(book_image).to_not be_valid  
    end

    it "should is_default accept only true or false" do
      book_image.is_default = nil
      expect(book_image).to_not be_valid  

      book_image.is_default = false
      expect(book_image).to be_valid  

      book_image.is_default = true
      expect(book_image).to be_valid
    end

    it "should be valid with all values correct" do
      expect(book_image).to be_valid
    end
  end
end