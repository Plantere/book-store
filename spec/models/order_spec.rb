require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    let(:order) {create(:order)}

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