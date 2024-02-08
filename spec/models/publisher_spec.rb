require 'rails_helper'

RSpec.describe Publisher, type: :model do
  describe 'validations' do
    subject(:publisher) { Publisher.new(name: "Penguin Random House", description: "Penguin Random House is a global publisher committed to publishing great books, connecting readers and authors globally, and spreading the love of reading. They also provide resources for authors looking to publish their works, including a guide to demystifying the publishing process.") } 
    let(:duplicate_publisher) {Publisher.create(name: "Penguin Random House", description: "Penguin Random House is a global publisher committed to publishing great books, connecting readers and authors globally, and spreading the love of reading. They also provide resources for authors looking to publish their works, including a guide to demystifying the publishing process.")}
    before { publisher.save }

    it "should not be valid without presence of name" do
      publisher.name = nil
      expect(publisher).to_not be_valid  
    end

    it "should not be valid with duplicate name" do
      expect(duplicate_publisher).to_not be_valid
    end

    it "should be valid with all values correct" do
      expect(publisher).to be_valid
    end
  end
end