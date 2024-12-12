class AddPriceToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :price, :decimal, precision: 10, scale: 2
  end
end
