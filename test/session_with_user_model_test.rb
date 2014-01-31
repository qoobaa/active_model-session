require "test_helper"

class User
  attr_accessor :id, :password, :email

  RECORDS = {
    {email: "alice@example.com"} => {id: 1, email: "alice@example.com", password: "alicesecret"},
    {email: "bob@example.com"}   => {id: 2, email: "bob@example.com",   password: "bobsecret"}
  }

  def self.find_by(options)
    attributes = RECORDS[options]
    new(attributes) if attributes.present?
  end

  def initialize(options)
    self.id       = options[:id]
    self.email    = options[:email]
    self.password = options[:password]
  end

  def authenticate(password)
    self.password == password
  end
end

class SessionWithUserModelTest < Test::Unit::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = @session = ActiveModel::Session.new
  end

  def test_is_valid_with_valid_credentials
    @session.email = "alice@example.com"
    @session.password = "alicesecret"
    assert @session.valid?
  end

  def test_returns_user_id_when_valid
    @session.email = "bob@example.com"
    @session.password = "bobsecret"
    assert @session.valid?
    assert_equal 2, @session.user_id
  end

  def test_is_invalid_when_user_does_not_exist
    @session.email = "non-existing@example.com"
    assert @session.invalid?
    assert @session.errors[:email].present?
  end

  def test_is_invalid_with_incorrect_password
    @session.email = "alice@example.com"
    @session.password = "wrong-password"
    assert @session.invalid?
    assert @session.errors[:password].present?
  end

  def test_is_invalid_without_email
    @session.email = nil
    assert @session.invalid?
    assert @session.errors[:email].present?
  end
end
