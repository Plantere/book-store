require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    let(:publisher) {Publisher.create(name: "Penguin Random House", description: "Penguin Random House is a global publisher committed to publishing great books, connecting readers and authors globally, and spreading the love of reading. They also provide resources for authors looking to publish their works, including a guide to demystifying the publishing process.")}
    let(:author) {Author.create(full_name: "George Orwell", birth_date: "2001-02-02")}
    let(:genre) {Genre.create(name: "Romance", description: "There is love somewhere in the world and it is in this genre of romance")}
    let(:book) { Book.create(publisher_id: publisher[:id], author_id: author[:id], genre_id: genre[:id], name: "1984", description: "1984” is a dystopian novel by George Orwell published in 1949. The novel is set in Airstrip One, a province of the superstate Oceania in a world of perpetual war, omnipresent government surveillance, and public manipulation", stock_quantity: 20, price: 15.99) } 
    
    let(:user) {User.create!(username: "example", email: "test@example.com", password_digest: "test_example123", status: 1,  user_type: 1)}
    let(:address) { Address.create!(user_id: user[:id], name: "Address 1", country: "United States", state: "New York", street: "West 42nd Street",  district: "Manhattan", city: "New York", complement: "Madame Toussauds", postal_code: "10036", number: 234, phone_number: "4383828382392", is_default: true) } 
    let(:order) { Order.create(user_id: user[:id], address_id: address[:id], transaction_id: "RANDOM_TRANSACTION_ID", price: 15.99) } 
    subject(:order_detail) { OrderDetail.new(order_id: order[:id], book_id: book[:id], price: 15.99, quantity: 1) }
    before { order_detail.save }

    it "should not be valid without presence of price" do
      order_detail.price = nil
      expect(order_detail).to_not be_valid  
    end

    it "should not be valid without presence of quantity" do
      order_detail.quantity = nil
      expect(order_detail).to_not be_valid  
    end

    it "should not be valid without presence of order_id" do
      order_detail.order_id = nil
      expect(order_detail).to_not be_valid  
    end

    it "should not be valid without presence of book_id" do
      order_detail.book_id = nil
      expect(order_detail).to_not be_valid  
    end

    it "should be valid with all values correct" do
      expect(order).to be_valid
    end
  end
end