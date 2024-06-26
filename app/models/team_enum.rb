require 'concerns/enumerable'

class TeamEnum
  include Enumerable

  def self.all
    {
      :CL => 'Council',
      :DE => 'Dark Elves',
      :DW => 'Dwarves',
      :TR => 'Tribe',
      :TF => 'Team Fortress',
      :SL => 'Shaolin'
    }
  end
end
