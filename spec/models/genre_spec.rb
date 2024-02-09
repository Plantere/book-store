require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'validations' do
    let(:genre) {create(:genre)}

    it "should not be valid without presence of name" do
      genre.name = nil
      expect(genre).to_not be_valid  
    end

    it "should not be valid without presence of description" do
      genre.description = nil
      expect(genre).to_not be_valid  
    end

    it "should be valid with all values correct" do
      expect(genre).to be_valid  
    end

  end
end