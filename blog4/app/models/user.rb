class User < ApplicationRecord
    has_secure_password
    has_many :blogs
    has_many :comments
    validates :username, presence: true, uniqueness: { case_sensitive: true }
    validates :email, presence: true
    validates :password, presence: true, length: { minimum: 6 }
end
