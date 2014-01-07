class AddGameToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :game, :string
  end
end
