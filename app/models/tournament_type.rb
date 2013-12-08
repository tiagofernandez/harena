require 'concerns/enumerable'

class TournamentType

  include Enumerable

  def self.all
    {
      :SRR => 'Round-robin',
      # :SKO => 'Knockout',
    }
  end

end
