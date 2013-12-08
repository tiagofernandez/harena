class Tournament < ActiveRecord::Base

  belongs_to :host,      :class_name => 'Player', :foreign_key => 'host_id'
  belongs_to :champion,  :class_name => 'Player', :foreign_key => 'champion_id'
  belongs_to :runner_up, :class_name => 'Player', :foreign_key => 'runner_up_id'

  has_many :matches
  has_many :registrations
  has_many :players, through: :registrations

  def round_robin?
    kind == 'SRR'
  end

  def can_be_managed_by?(player)
    host.id == player.id
  end

  def registered?(player)
    Registration.where(tournament_id: id, player: player).count == 1
  end

  def get_accepted_players
    players = Player.joins(:tournaments).where(
      "tournament_id = :tournament_id AND accepted = :accepted",
      { tournament_id: id, accepted: true })
    players
  end

  def get_finished_matches
    matches = Match.where(
      "tournament_id = :tournament_id AND winner_id IS NOT NULL",
      { tournament_id: id })
    matches
  end
end
