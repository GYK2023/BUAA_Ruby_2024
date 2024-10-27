class DropAllTables < ActiveRecord::Migration[7.2]
  def up
    drop_table :blogs
  end
  
  def down
    create_table :blogs do |t|
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
