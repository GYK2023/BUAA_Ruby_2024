class AddStatusToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :status, :string, default: "active", null: false
  end
end
