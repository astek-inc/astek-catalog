module Tokenable
  extend ActiveSupport::Concern

  included do
    validates :token, presence: true #, uniqueness: true
  end

  module ClassMethods

    def generate_token
      loop do
        random_token = SecureRandom.urlsafe_base64(32, false)
        break random_token unless self.exists?(token: random_token)
      end
    end

  end
end
