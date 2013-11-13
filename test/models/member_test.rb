require 'test_helper'

class MemberTest < ActiveSupport::TestCase

  def new_member(attributes={})
    attributes[:username]              ||= 'tester'
    attributes[:email]                 ||= 'tester@acme.com'
    attributes[:password]              ||= '0123456789'
    attributes[:password_confirmation] ||= '0123456789'
    member = Member.new(attributes)
    member.valid? # run validations
    member
  end

  test "should validate member" do
    assert new_member.valid?
  end

  test "should require unique username" do
    username = 'foobar'
    assert new_member(:username => username).save!
    member = new_member(:username => username)
    assert_equal ["has already been taken"], member.errors[:username]
  end

  test "should require username" do
    member = new_member(:username => '')
    assert_equal ["can't be blank", "should only contain letters and numbers"], member.errors[:username]
  end

  test "should require only letters and numbers in username" do
    member = new_member(:username => 't&$t&r')
    assert_equal ["should only contain letters and numbers"], member.errors[:username]
  end

  test "should reject spaces in username" do
    member = new_member(:username => 't e s t e r')
    assert_equal ["should only contain letters and numbers"], member.errors[:username]
  end

  test "should require email" do
    member = new_member(:email => '')
    assert_equal ["can't be blank"], member.errors[:email]
  end

  test "should require well-formed email" do
    member = new_member(:email => 'tester at acme dot com')
    assert_equal ["is invalid"], member.errors[:email]
  end

  test "should require unique email" do
    email = 'foo@bar.baz'
    assert new_member(:email => email).save!
    member = new_member(:email => email)
    assert_equal ["has already been taken"], member.errors[:email]
  end

  test "should require password" do
    member = new_member(:password => '', :password_confirmation => '')
    assert_equal ["can't be blank"], member.errors[:password]
  end

  test "should match password" do
    member = new_member(:password_confirmation => '0987654321')
    assert_equal ["doesn't match Password"], member.errors[:password_confirmation]
  end

  test "should validate password length" do
    member = new_member(:password => '0123', :password_confirmation => '0123')
    assert_equal ["is too short (minimum is 8 characters)"], member.errors[:password]
  end

end
