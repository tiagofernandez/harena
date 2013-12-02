class Match < ActiveRecord::Base

  belongs_to :player1, :class_name => 'Player', :foreign_key => 'player1_id'
  belongs_to :player2, :class_name => 'Player', :foreign_key => 'player2_id'
  belongs_to :winner,  :class_name => 'Player', :foreign_key => 'winner_id'

  def can_be_managed_by?(player)
    match_player = player1.id == player.id || player2.id == player.id
    match_player || Tournament.find(tournament_id).host.id == player.id
  end
end
