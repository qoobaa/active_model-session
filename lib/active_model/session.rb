require "active_model/session/version"
require "active_model"

module ActiveModel
  class Session
    include Model

    attr_accessor :password, :user
    attr_reader :email

    validates :email, presence: true, if: -> { user.blank? }
    validate :existence, if: -> { email.present? }
    validate :authenticity, if: -> { user.present? }
    delegate :id, :authenticate, to: :user, prefix: true, allow_nil: true

    def email=(email)
      @email = email
      @user = User.find_by(email: email)
    end

    private

    def existence
      errors.add(:email, :invalid) if user.blank?
    end

    def authenticity
      errors.add(:password, :invalid) unless user_authenticate(password)
    end
  end
end
