require 'rails_helper'

RSpec.describe Pet, type: :model do
  subject {
      described_class.new(fullname: "Rex", gender:"macho", breed: "Poodle", user: User.new)
    }
  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.fullname = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a gender" do
      subject.gender = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a breed" do
      subject.breed = nil
      expect(subject).to_not be_valid
    end

    it "is not valid if not assigned to a user" do
      subject.user = nil
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it "has a owner" do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end
  end

end
