require 'concerns/enumerable'

class TournamentEnum
  include Enumerable

  def self.all
    {
      :SRR => 'Round-robin',
      # :SKO => 'Knockout',
    }
  end
end
