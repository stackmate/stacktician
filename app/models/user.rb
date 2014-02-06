# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :remember_token, :cs_api_key, :cs_sec_key, :api_key, :sec_key
  #TODO api_key and sec_key need to be added above. done as of now to allow these fields to show up on settings tab
  has_secure_password
  has_many :stacks, dependent: :destroy
  has_many :stack_templates, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  #before_save :perhaps_get_keys
  before_save :set_api_keys

  validates :name, presence: true,  length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  #validates :cs_api_key, presence: true
  #validates :cs_sec_key, presence: true
  #TODO decide on integrated CCP users

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def set_api_keys
      if self.api_key.nil?
        self.api_key = SecureRandom.urlsafe_base64(64)
      end
      if self.sec_key.nil?
        self.sec_key = SecureRandom.urlsafe_base64(64)
      end
    end

    def perhaps_get_keys
      keypair = Stacktician::CloudStack::create_and_get_keys(self.name, self.email, self.password)
      if keypair && self.cs_api_key.to_s.empty? && self.cs_sec_key.to_s.empty?
      #TODO better key validation
          self.cs_api_key = keypair[:api_key]
          self.cs_sec_key = keypair[:sec_key]
      end
    end

end
