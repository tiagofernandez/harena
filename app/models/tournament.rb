class Tournament < ActiveRecord::Base

  belongs_to :creator,   :class_name => 'Player', :foreign_key => 'creator_id'
  belongs_to :champion,  :class_name => 'Player', :foreign_key => 'champion_id'
  belongs_to :runner_up, :class_name => 'Player', :foreign_key => 'runner_up_id'

  has_many :matches
  has_many :registrations
  has_many :players, through: :registrations

end
