require "test_helper"

class SessionWithoutUserModelTest < Test::Unit::TestCase
  def setup
    Object.send(:remove_const, :User) if defined?(User)
  end

  test "is invalid when user model is nil" do
    session = ActiveModel::Session.new(user: nil, email: "alice@example.com", password: "secret")
    assert session.invalid?
  end

  test "is invalid when user does not authenticate" do
    user = Object.new
    def user.authenticate(password)
      password == "secret"
    end
    session = ActiveModel::Session.new(user: user, email: "alice@example.com", password: "wrongsecret")
    assert session.invalid?
  end

  test "is valid when user authenticates" do
    user = Object.new
    def user.authenticate(password)
      password == "secret"
    end
    session = ActiveModel::Session.new(user: user, email: "alice@example.com", password: "secret")
    assert session.valid?
  end
end
