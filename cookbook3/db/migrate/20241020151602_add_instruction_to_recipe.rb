class AddInstructionToRecipe < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :instructions, :string
  end
end
