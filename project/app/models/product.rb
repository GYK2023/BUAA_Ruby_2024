class Product < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  
  has_many :cart_items, dependent: :destroy
  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes }
  # 验证字段有效性
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :sales, numericality: { greater_than_or_equal_to: 0 }
  
  # 自定义方法：减少库存并增加销量
  def sell(quantity)
    return false if quantity > stock
  
    self.stock -= quantity
    self.sales += quantity
    save
  end

  def active?
    status == "active"
  end

  def inactive?
    status == "inactive"
  end
end
  