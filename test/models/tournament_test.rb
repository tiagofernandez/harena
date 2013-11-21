require 'test_helper'

class TournamentTest < ActiveSupport::TestCase

  def setup
    @player1 = players(:random1)
    @player2 = players(:random2)
  end

  test "should create a tournament" do
    tournament = Tournament.new({
      :title   => 'Death Arena',
      :kind    => 'RR',
      :rules   => 'Last one standing wins.',
      :started => true,
    })
    assert tournament.save!
    assert tournament.id
    assert_equal 1, Tournament.all.size
  end

end
