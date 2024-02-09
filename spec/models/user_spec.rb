require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }

    it "should not be valid without presence of username" do
      user.username = nil
      expect(user).to_not be_valid
    end
  
    it "should not be valid without presence of email" do
      user.email = nil
      expect(user).to_not be_valid
    end
  
    it "should be in format of a email" do
      user.email = "examplegmail.com"
      expect(user).to_not be_valid
    end
  
    it "should not be valid without presence of password_digest" do 
      user.password_digest = nil
      expect(user).to_not be_valid
    end
    
    it "should be status a numericality value" do
      user.status = "a"
      expect(user).to_not be_valid
    end
  
    it "should be user_type a numericality value" do 
      user.user_type = "b"
      expect(user).to_not be_valid
    end

    it "should be email unique" do 
      user
      expect(build(:user, username: "john_replicate")).not_to be_valid
    end

    it "should username be a unique" do 
      user
      expect(build(:user, email: "john_replicate@example.com")).not_to be_valid
    end
  end
end