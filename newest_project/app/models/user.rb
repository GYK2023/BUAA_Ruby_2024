class User < ApplicationRecord
  has_one :cart, dependent: :destroy
  has_many :addresses, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  authentication_keys = [:username] # 将认证键设置为username

  validates :username, presence: true, uniqueness: true
  enum role: {
    buyer: 0,
    admin: 1
  }
  def is_admin?
    role == "admin"
  end
end
