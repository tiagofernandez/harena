require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  def new_player(attributes={})
    attributes[:username]              ||= 'tester'
    attributes[:avatar]                ||= 106
    attributes[:timezone]              ||= 'GMT+01:00 Paris'
    attributes[:email]                 ||= 'tester@acme.com'
    attributes[:password]              ||= '0123456789'
    attributes[:password_confirmation] ||= '0123456789'
    player = Player.new(attributes)
    player.valid? # run validations
    player
  end

  test "should validate player" do
    assert new_player.valid?
  end

  test "should require an username" do
    player = new_player(:username => '')
    assert_equal ["can't be blank", "is too short (minimum is 3 characters)", "should only contain letters and numbers"], player.errors[:username]
  end

  test "should require unique username" do
    username = 'foobar'
    assert new_player(:username => username).save!
    [username, username.upcase].each do |u|
      player = new_player(:username => u)
      assert_equal ["has already been taken"], player.errors[:username]
    end
  end

  test "should require username with more than 3 characters" do
    player = new_player(:username => 'ab')
    assert_equal ["is too short (minimum is 3 characters)"], player.errors[:username]
  end

  test "should require username with less than 20 characters" do
    player = new_player(:username => 'a' * 21)
    assert_equal ["is too long (maximum is 20 characters)"], player.errors[:username]
  end

  test "should require only letters and numbers in username" do
    player = new_player(:username => 't&$t&r')
    assert_equal ["should only contain letters and numbers"], player.errors[:username]
  end

  test "should reject spaces in username" do
    player = new_player(:username => 't e s t e r')
    assert_equal ["should only contain letters and numbers"], player.errors[:username]
  end

  test "should require email" do
    player = new_player(:email => '')
    assert_equal ["can't be blank"], player.errors[:email]
  end

  test "should require well-formed email" do
    player = new_player(:email => 'tester at acme dot com')
    assert_equal ["is invalid"], player.errors[:email]
  end

  test "should require unique email" do
    email = 'foo@bar.baz'
    assert new_player(:email => email).save!
    player = new_player(:email => email)
    assert_equal ["has already been taken"], player.errors[:email]
  end

  test "should require password" do
    player = new_player(:password => '', :password_confirmation => '')
    assert_equal ["can't be blank"], player.errors[:password]
  end

  test "should match password" do
    player = new_player(:password_confirmation => '0987654321')
    assert_equal ["doesn't match Password"], player.errors[:password_confirmation]
  end

  test "should validate password length" do
    player = new_player(:password => '123', :password_confirmation => '0123')
    assert_equal ["is too short (minimum is 4 characters)"], player.errors[:password]
  end

  test "should validate timezone format" do
    TimezoneEnum.all(as_list=true).each do |t|
      player = new_player(:timezone => t)
      assert player.errors.empty?, "failed to validate #{t}"
    end
    ['', 'GMT 01:00 Paris', 'GMT+0100 Paris', '+0100 Paris', 'gmt+01:00 Paris'].each do |t|
      player = new_player(:timezone => t)
      assert player.errors[:timezone], "failed to validate #{t}"
    end
  end
end
