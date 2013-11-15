require "test_helper"

class SessionWithoutUserModelTest < Test::Unit::TestCase
  def setup
    Object.send(:remove_const, :User) if defined?(User)
  end

  def test_is_invalid_when_user_model_is_nil
    session = ActiveModel::Session.new(user: nil, email: "alice@example.com", password: "secret")
    assert session.invalid?
  end

  def test_is_invalid_when_user_does_not_authenticate
    user = Object.new
    def user.authenticate(password)
      password == "secret"
    end
    session = ActiveModel::Session.new(user: user, email: "alice@example.com", password: "wrongsecret")
    assert session.invalid?
  end

  def test_is_valid_when_user_authenticates
    user = Object.new
    def user.authenticate(password)
      password == "secret"
    end
    session = ActiveModel::Session.new(user: user, email: "alice@example.com", password: "secret")
    assert session.valid?
  end
end
