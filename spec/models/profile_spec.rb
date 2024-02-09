require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'validations' do
    let(:profile) {create(:profile)}

    it "should not be valid without presence of first_name" do
      profile.first_name = nil
      expect(profile).to_not be_valid
    end

    it "should not be valid without presence of last_name" do
      profile.last_name = nil
      expect(profile).to_not be_valid
    end

    it "should be valid with all values correct" do
      expect(profile).to be_valid
    end
  end
end