class Address < ApplicationRecord
  belongs_to :user
  validates :name, :phone_num, :address, presence: true
  validates :phone_num, numericality: { only_integer: true }, length: { is: 11 }, allow_blank: true

  # 确保只有一个默认地址
  after_save :set_default_address, if: :default?

  private

  def set_default_address
    # 将所有其他地址的默认地址标记为 false
    Address.where.not(id: self.id).update_all(default: false)
  end

end
