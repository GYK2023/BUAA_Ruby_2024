class AddAddressToOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :orders, :address, foreign_key: true
  end
end
