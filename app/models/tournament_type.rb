require 'concerns/enumerable'

class TournamentType

  include Enumerable

  def self.all
    {
      :RR => 'Round-robin',
      :KO => 'Knockout'
    }
  end

end
