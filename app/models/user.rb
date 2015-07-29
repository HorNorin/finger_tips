require 'digest/sha1'

class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: :slugged
  
  attr_accessor :password, :password_confirmation, :remember_me
  
  has_many :comments
  
  enum role: [:normal, :admin]
  
  mount_uploader :avatar, AvatarUploader
  
  before_save :encrypt_password, if: :new_record_or_passwod_present?
  before_save :generate_activation_token, unless: :account_activated?
  after_save :send_activation_mail
  
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_length_of :username, within: 5..25
  
  validates_length_of :password, minimum: 6, if: :new_record_or_passwod_present?
  validates_presence_of :password, if: :new_record?
  
  validates_confirmation_of :password, if: :new_record_or_passwod_present?
  
  validates_format_of :email, with: /\A[^@\s]+@\w+\.\w{3,4}\z/i
  
  def authenticate(password)
    password_hash == encrypt(password)
  end
  
  private
  
  def encrypt_password
    self.password_hash = encrypt(password)
  end
  
  def encrypt(password)
    Digest::SHA1.hexdigest password
  end
  
  def new_record_or_passwod_present?
    new_record? || !password.blank?
  end
  
  def send_activation_mail
    Notifier.instruction(self).deliver_now unless account_activated?
  end
  
  def generate_activation_token
    self.activation_token = SecureRandom.urlsafe_base64
  end
end
