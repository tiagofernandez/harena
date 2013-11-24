class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.references :creator
      t.references :champion
      t.references :runner_up
      t.string     :title,     :null => false, :default => ""
      t.string     :kind,      :null => false, :default => ""
      t.string     :rules,     :null => false, :default => ""
      t.boolean    :started,   :null => false, :default => false
      t.timestamps
    end
 
    create_table :tournaments_players do |t|
      t.belongs_to :tournament
      t.belongs_to :player
      t.boolean    :accepted, :null => false, :default => false
    end

    add_column :matches, :tournament_id, :integer

    add_index :tournaments, :creator_id
    add_index :tournaments, :champion_id
    add_index :tournaments, :runner_up_id
  end
end
