class DropAllTables < ActiveRecord::Migration[7.2]
  def up
    tables = ActiveRecord::Base.connection.tables
    tables.each do |table|
      drop_table table, force: :cascade
    end
  end

  def down
  end
end
