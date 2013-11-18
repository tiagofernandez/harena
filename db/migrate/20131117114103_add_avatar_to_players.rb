class AddAvatarToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :avatar, :integer, :null => false, :default => 0
  end
end
