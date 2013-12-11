class Registration < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :player
  validates_presence_of :tournament, :player
end
