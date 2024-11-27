class ChangePriceTypeInOrderItems < ActiveRecord::Migration[7.2]
  def change
    change_column :order_items, :price, :decimal, precision: 10, scale: 2
  end
end
