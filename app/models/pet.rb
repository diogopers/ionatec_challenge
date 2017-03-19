class Pet < ApplicationRecord
  validates_presence_of :fullname, :gender, :breed

  belongs_to :user
end
