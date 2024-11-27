class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_items, dependent: :destroy
  validates :status, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  
end
