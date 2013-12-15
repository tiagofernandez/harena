class AddTimezoneToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :timezone, :string
  end
end
