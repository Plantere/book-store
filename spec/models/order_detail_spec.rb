require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    let(:order_detail) {create(:order_detail)}

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
      expect(order_detail).to be_valid
    end
  end
end