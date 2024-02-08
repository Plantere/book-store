require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { User.new(username: "example", email: "test@example.com", password_digest: "test_example123", status: 1,  user_type: 1) } 
    before { subject.save }

    it "should not be valid without presence of username" do
      subject.username = nil
      expect(subject).to_not be_valid
    end
  
    it "should not be valid without presence of email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end
  
    it "should be in format of a email" do
      subject.email = "examplegmail.com"
      expect(subject).to_not be_valid
    end
  
    it "should not be valid without presence of password_digest" do 
      subject.password_digest = nil
      expect(subject).to_not be_valid
    end
    
    it "should be status a numericality value" do
      subject.status = "a"
      expect(subject).to_not be_valid
    end
  
    it "should be user_type a numericality value" do 
      subject.user_type = "b"
      expect(subject).to_not be_valid
    end

    it "should be email unique" do 
      other_user = User.new(username: "not_know", email: "test@example.com", password_digest: "test_example123", status: 1,  user_type: 1)
      expect(other_user).not_to be_valid
    end

    it "should username be a unique" do 
      other_user = User.new(username: "example", email: "not_know@example.com", password_digest: "test_example123", status: 1,  user_type: 1)
      expect(other_user).not_to be_valid
    end
  end


  describe 'methods' do 
    subject { User.new(username: "example", email: "test@example.com", password_digest: "test_example123", status: 1,  user_type: 1) } 
    before { subject.save }


    it "should return false when email is not registered" do
      expect(User.registered?({email: "not_test@example.com", username: "not_example"})).to be_falsey
    end

    it "should return true when email is registered" do
      expect(User.registered?({email: "test@example.com", username: "not_example"})).to be_truthy
    end

    it "should return false when username is not registered" do
      expect(User.registered?({email: "not_test@example.com", username: "not_example"})).to be_falsey
    end

    it "should return true when username is registered" do
      expect(User.registered?({email: "not_test@example.com", username: "example"})).to be_truthy
    end

  end
end