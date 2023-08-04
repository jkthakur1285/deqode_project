class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :email, presence: true, length: { minimum: 10, maximum: 255 },format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6, maximum: 255 }, on: :create
  validates :password, length: { minimum: 6, maximum: 255 }, if: -> { self.password.present? }
end
