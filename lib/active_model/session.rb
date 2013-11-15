require "active_model/session/version"
require "active_model"

module ActiveModel
  class Session
    include Model

    attr_accessor :email, :password
    attr_writer :user

    validates :email, presence: true
    validate :authenticity, if: -> { email.present? }
    delegate :id, :authenticate, to: :user, prefix: true, allow_nil: true

    def user
      return @user if defined?(@user)
      @user = User.find_by(email: email)
    end

    private

    def authenticity
      errors.add(:password, :invalid) unless user_authenticate(password)
    end
  end
end
