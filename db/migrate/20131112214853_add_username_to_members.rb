class AddUsernameToMembers < ActiveRecord::Migration
  def change
    add_column :members, :username, :string, :null => false, :default => ""
    add_index :members, :username, unique: true
  end
end
