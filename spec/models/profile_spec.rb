require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'validations' do
    let(:user) {User.create!(username: "example", email: "test@example.com", password_digest: "test_example123", status: 1,  user_type: 1)}
    subject(:profile) { Profile.new(first_name: "example", last_name: "test", user_id: user[:id]) } 
    before { profile.save }

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