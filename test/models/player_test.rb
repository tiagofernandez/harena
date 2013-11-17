require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  def new_player(attributes={})
    attributes[:username]              ||= 'tester'
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

  test "should require unique username" do
    username = 'foobar'
    assert new_player(:username => username).save!
    player = new_player(:username => username)
    assert_equal ["has already been taken"], player.errors[:username]
  end

  test "should require username" do
    player = new_player(:username => '')
    assert_equal ["can't be blank", "should only contain letters and numbers"], player.errors[:username]
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
    player = new_player(:password => '0123', :password_confirmation => '0123')
    assert_equal ["is too short (minimum is 8 characters)"], player.errors[:password]
  end

end
