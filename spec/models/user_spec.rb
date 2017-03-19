require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(fullname: "Maria", phone:"519998888")
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.fullname = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a phone" do
      subject.phone = nil
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do

  end
end
