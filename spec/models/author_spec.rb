require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validations' do
    let(:author) {create(:author)}
    let(:duplicate_author) {build(:author)}

    it "should not be valid without presence of full_name" do
      author.full_name = nil
      expect(author).to_not be_valid  
    end

    it "should not be valid without presence of birth_date" do
      author.full_name = nil
      expect(author).to_not be_valid  
    end
    
    it "should not be valid with duplicate full_name and birth_date" do
      author
      expect(duplicate_author).to_not be_valid
    end

    it "should be valid with different full_name and same birth_date" do
      duplicate_author.full_name = "Anthony Charizard"
      expect(duplicate_author).to be_valid
    end

    it "should be valid with same full_name but different birth_date" do
      duplicate_author.birth_date = "2001-03-03"
      expect(duplicate_author).to be_valid
    end

    it "should be valid with all values correct" do
      expect(author).to be_valid
    end
  end
end