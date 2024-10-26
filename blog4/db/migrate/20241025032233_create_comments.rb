class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :blog, null: false, foreign_key: true
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
