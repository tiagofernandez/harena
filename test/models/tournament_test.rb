require 'test_helper'

class TournamentTest < ActiveSupport::TestCase

  def new_tournament(title)
    tournament = Tournament.new(:title => title)
    tournament.valid? # run validations
    tournament
  end

  def setup
    @player1 = players(:random1)
    @player2 = players(:random2)
  end

  test "should create a tournament" do
    tournament = Tournament.new({
      :title   => 'Death Arena',
      :kind    => 'SEL',
      :rules   => 'Last one standing wins.',
      :started => true
    })
    assert tournament.save!
    assert tournament.id
  end

  test "should require a title" do
    tournament = new_tournament('')
    assert_equal ["can't be blank", "is too short (minimum is 10 characters)", "should only contain letters, numbers, dashes, and underscores"], tournament.errors[:title]
  end

  test "should require unique title" do
    title = 'foo_bar_baz_abc'
    assert new_tournament(title).save!
    [title, title.upcase].each do |t|
      tournament = new_tournament(t)
      assert_equal ["has already been taken"], tournament.errors[:title]
    end
  end

  test "should require title with more than 10 characters" do
    tournament = new_tournament('abcde')
    assert_equal ["is too short (minimum is 10 characters)"], tournament.errors[:title]
  end

  test "should require title with less than 40 characters" do
    tournament = new_tournament('a' * 41)
    assert_equal ["is too long (maximum is 40 characters)"], tournament.errors[:title]
  end

  test "should require only letters numbers dashes and underscores in title" do
    tournament = new_tournament('t&$t&r' * 4)
    assert_equal ["should only contain letters, numbers, dashes, and underscores"], tournament.errors[:title]
  end

end
