class User < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
  has_many :orders
  has_one :cart, dependent: :destroy
  has_many :addresses, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  authentication_keys = [:username] # 将认证键设置为username

  validates :username, presence: true, uniqueness: true
  ROLES = ["buyer", "admin"]
  validates :role, presence: true, inclusion: { in: ROLES }
  
  def is_admin?
    role == "admin"
  end
end
