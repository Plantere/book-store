require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    let(:user) {User.create!(username: "example", email: "test@example.com", password_digest: "test_example123", status: 1,  user_type: 1)}
    subject(:address) { Address.new(user_id: user[:id], name: "Address 1", country: "United States", state: "New York", street: "West 42nd Street",  district: "Manhattan", city: "New York", complement: "Madame Toussauds", postal_code: "10036", number: 234, phone_number: "4383828382392", is_default: true) } 
    before { address.save }

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