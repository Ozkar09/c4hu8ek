class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :generate_token
  before_create :set_auth_token

  private
  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_token    
  end

  private
    def generate_token
      self.api_token ||= SecureRandom.hex if new_record?
    end
end
