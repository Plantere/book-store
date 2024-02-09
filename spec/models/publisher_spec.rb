require 'rails_helper'

RSpec.describe Publisher, type: :model do
  describe 'validations' do
    let(:publisher) {create(:publisher)}
    let(:duplicate_publisher) {build(:publisher)}


    it "should not be valid without presence of name" do
      publisher.name = nil
      expect(publisher).to_not be_valid  
    end

    it "should not be valid with duplicate name" do
      publisher
      expect(duplicate_publisher).to_not be_valid
    end

    it "should be valid with all values correct" do
      expect(publisher).to be_valid
    end
  end
end