class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :stock
      t.integer :sales
      t.string :image_url

      t.timestamps
    end
  end
end
