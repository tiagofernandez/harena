class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :player1
      t.references :player2
      t.references :winner
      t.string     :player1_team, :null => false, :default => ""
      t.string     :player2_team, :null => false, :default => ""
      t.string     :victory,      :null => false, :default => ""
      t.integer    :map,          :null => false, :default => -1
      t.timestamps
    end

    add_index :matches, :player1_id
    add_index :matches, :player2_id
    add_index :matches, :winner_id
  end
end
