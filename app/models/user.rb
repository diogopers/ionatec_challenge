class User < ApplicationRecord
  validates_presence_of :fullname, :phone

  has_many :pets, dependent: :destroy
end
