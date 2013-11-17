require 'concerns/enumerable'

class MapType

  include Enumerable

  def self.all
    {
      1 => 'GameBoard-hd',
      2 => 'GameBoard02-hd',
      3 => 'GameBoard03-hd',
      4 => 'DwarfGameBoard-hd',
      5 => 'OrcGameBoard-hd',
      6 => 'GameBoard_TF2-hd',
      7 => 'GameBoard_Shaolin-hd'
    }
  end

end
