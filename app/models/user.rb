class User < ActiveRecord::Base

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  attr_accessor :is_admin

  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)

    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create( #name: data['name'],
           email: data['email'],
           password: Devise.friendly_token[0,20]
        )
    end

    user

  end

  def is_admin
    self.has_role? :admin
  end

  def after_database_authentication
    puts self.email
    puts '- '*30
  end

end
