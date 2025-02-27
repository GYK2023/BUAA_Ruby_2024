class AddUserAddressIdToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :user_address_id, :integer
  end
end
