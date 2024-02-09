require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    let(:address) {create(:address)}

    it "should not be valid without presence of name" do
      address.name = nil
      expect(address).to_not be_valid  
    end

    it "should not be valid without presence of country" do
      address.country = nil
      expect(address).to_not be_valid  
    end

    it "should not be valid without presence of state" do
      address.state = nil
      expect(address).to_not be_valid  
    end

    it "should not be valid without presence of district" do
      address.district = nil
      expect(address).to_not be_valid  
    end

    it "should not be valid without presence of number" do
      address.number = nil
      expect(address).to_not be_valid  
    end

    it "should not be valid without presence of postal_code" do
      address.postal_code = nil
      expect(address).to_not be_valid  
    end

    it "should not be valid without presence of phone_number" do
      address.phone_number = nil
      expect(address).to_not be_valid  
    end

    it "should not be valid without presence of city" do
      address.city = nil
      expect(address).to_not be_valid  
    end

    it "should not be valid without presence of is_default" do
      address.is_default = nil
      expect(address).to_not be_valid 
    end

    it "should be valid with all values correct" do
      expect(address).to be_valid
    end
  end
end