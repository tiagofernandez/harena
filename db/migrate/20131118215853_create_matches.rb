class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :player1
      t.references :player2
      t.references :winner
      t.string     :player1_team
      t.string     :player2_team
      t.string     :victory
      t.integer    :map
      t.timestamps
    end

    add_index :matches, :player1_id
    add_index :matches, :player2_id
    add_index :matches, :winner_id
  end
end
