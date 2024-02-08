require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    let(:user) {User.create!(username: "example", email: "test@example.com", password_digest: "test_example123", status: 1,  user_type: 1)}
    let(:address) { Address.create!(user_id: user[:id], name: "Address 1", country: "United States", state: "New York", street: "West 42nd Street",  district: "Manhattan", city: "New York", complement: "Madame Toussauds", postal_code: "10036", number: 234, phone_number: "4383828382392", is_default: true) } 
    subject(:order) { Order.new(user_id: user[:id], address_id: address[:id], transaction_id: "RANDOM_TRANSACTION_ID", price: 15.99) } 
    before { order.save }

    it "should not be valid without presence of transaction_id" do
      order.transaction_id = nil
      expect(order).to_not be_valid  
    end

    it "should not be valid without presence of price" do
      order.price = nil
      expect(order).to_not be_valid  
    end

    it "should not be valid without presence of address_id" do
      order.address_id = nil
      expect(order).to_not be_valid  
    end

    it "should not be valid without presence of user_id" do
      order.user_id = nil
      expect(order).to_not be_valid  
    end

    it "should be valid with all values correct" do
      expect(order).to be_valid
    end
  end
end