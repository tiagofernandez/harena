require 'concerns/enumerable'

class MapEnum
  include Enumerable

  def self.all
    {
      0 => 'GameBoard-hd',
      1 => 'GameBoard02-hd',
      2 => 'GameBoard03-hd',
      3 => 'DwarfGameBoard-hd',
      4 => 'OrcGameBoard-hd',
      5 => 'GameBoard_TF2-hd',
      6 => 'GameBoard_Shaolin-hd'
    }
  end
end
