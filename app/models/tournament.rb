class Tournament < ActiveRecord::Base

  belongs_to :host,      :class_name => 'Player', :foreign_key => 'host_id'
  belongs_to :champion,  :class_name => 'Player', :foreign_key => 'champion_id'
  belongs_to :runner_up, :class_name => 'Player', :foreign_key => 'runner_up_id'

  has_many :matches
  has_many :registrations
  has_many :players, through: :registrations

  def round_robin?
    single_round_robin? or double_round_robin?
  end

  def single_round_robin?
    kind == 'SRR'
  end

  def double_round_robin?
    kind == 'DRR'
  end

  def can_be_managed_by?(player)
    host_id == player.id
  end
end
