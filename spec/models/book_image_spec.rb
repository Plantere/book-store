require 'rails_helper'

RSpec.describe BookImage, type: :model do
  describe 'validations' do
    let(:publisher) {Publisher.create(name: "Penguin Random House", description: "Penguin Random House is a global publisher committed to publishing great books, connecting readers and authors globally, and spreading the love of reading. They also provide resources for authors looking to publish their works, including a guide to demystifying the publishing process.")}
    let(:author) {Author.create(full_name: "George Orwell", birth_date: "2001-02-02")}
    let(:genre) {Genre.create(name: "Romance", description: "There is love somewhere in the world and it is in this genre of romance")}
    let(:book) { Book.create(publisher_id: publisher[:id], author_id: author[:id], genre_id: genre[:id], name: "1984", description: "1984” is a dystopian novel by George Orwell published in 1949. The novel is set in Airstrip One, a province of the superstate Oceania in a world of perpetual war, omnipresent government surveillance, and public manipulation", stock_quantity: 20, price: 15.99) } 
    subject(:book_image) { BookImage.new(book_id: book[:id], path: "/storage/image/book_page.png", is_default: true) } 
    before { book_image.save }

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