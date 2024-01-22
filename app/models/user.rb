class User < ApplicationRecord
  has_secure_password

  validates :username, :password_digest, :email, presence: true
  validates :username, uniqueness: true, length: { minimum:4 }
  validates :email, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP # Ref. https://github.com/ruby/ruby/blob/ruby_2_6/lib/uri/mailto.rb#L55
  validates :status, numericality: true
  validates :user_type, numericality: true

  has_many :address, dependent: :destroy
  has_many :telephone, dependent: :destroy
  has_many :order, dependent: :destroy
  has_one :profile, dependent: :destroy

  def self.registered?(user_params)
    exists?(email: user_params[:email]) || exists?(username: user_params[:username])
  end
end
