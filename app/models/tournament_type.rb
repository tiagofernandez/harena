require 'concerns/enumerable'

class TournamentType

  include Enumerable

  def self.all
    {
      :SRR => 'Single round-robin',
      :DRR => 'Double round-robin',
      # :SEL => 'Single-elimination',
      # :DEL => 'Double-elimination'
    }
  end

end
