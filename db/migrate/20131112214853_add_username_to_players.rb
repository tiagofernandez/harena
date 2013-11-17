class AddUsernameToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :username, :string, :null => false, :default => ""
    add_index :players, :username, unique: true
  end
end
