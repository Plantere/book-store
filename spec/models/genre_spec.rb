require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'validations' do
    subject(:genre) { Genre.new(name: "Romance", description: "There is love somewhere in the world and it is in this genre of romance") } 
    let(:duplicate_genre) {Genre.create(name: "Romance", description: "There is love somewhere in the world and it is in this genre of romance")}
    before { genre.save }


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