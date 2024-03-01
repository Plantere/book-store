class User < ApplicationRecord
  has_secure_password


  validates :username, :password_digest, :email, presence: true
  validates :username, uniqueness: { case_sensitive: false }, length: { minimum:4 }
  validates :email, uniqueness: { case_sensitive: false }, format: URI::MailTo::EMAIL_REGEXP # Ref. https://github.com/ruby/ruby/blob/ruby_2_6/lib/uri/mailto.rb#L55
  validates :status, numericality: true
  validates :user_type, numericality: true

  has_many :address, dependent: :destroy
  has_many :order, dependent: :destroy
  has_one :profile, dependent: :destroy
  
  accepts_nested_attributes_for :profile

  before_save :downcase_fields

  def self.registered?(user_params)
    exists?(email: user_params[:email].downcase) || exists?(username: user_params[:username].downcase)
  end

  def downcase_fields
    self.email.downcase!
    self.username.downcase!
  end
end
