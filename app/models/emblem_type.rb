require 'concerns/enumerable'

class EmblemType

  include Enumerable

  def self.all
    {
      0 => 'Hum-Emblem-hd.png',
      1 => 'DE-Emblem-hd.png',
      2 => 'DW-Emblem-hd.png',
      3 => 'OR-Emblem-hd.png',
      4 => 'TF2a-Emblem-hd.png',
      5 => 'SH-Emblem-hd.png'
    }
  end

end

