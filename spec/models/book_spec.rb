require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    let(:publisher) {Publisher.create(name: "Penguin Random House", description: "Penguin Random House is a global publisher committed to publishing great books, connecting readers and authors globally, and spreading the love of reading. They also provide resources for authors looking to publish their works, including a guide to demystifying the publishing process.")}
    let(:author) {Author.create(full_name: "George Orwell", birth_date: "2001-02-02")}
    let(:genre) {Genre.create(name: "Romance", description: "There is love somewhere in the world and it is in this genre of romance")}
    subject(:book) { Book.new(publisher_id: publisher[:id], author_id: author[:id], genre_id: genre[:id], name: "1984", description: "1984” is a dystopian novel by George Orwell published in 1949. The novel is set in Airstrip One, a province of the superstate Oceania in a world of perpetual war, omnipresent government surveillance, and public manipulation", stock_quantity: 20, price: 15.99) } 
    before { book.save }

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