require 'concerns/enumerable'

class VictoryType

  include Enumerable

  def self.all
    {
      :TKO => 'Technical Knockout',
      :CK  => 'Crystal Kill',
      :R   => 'Resignation',
      :F   => 'Forfeit'
    }
  end

end
