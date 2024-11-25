class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :phone_num
      t.string :address
      t.boolean :default

      t.timestamps
    end
  end
end
