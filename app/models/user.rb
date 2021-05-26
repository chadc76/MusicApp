# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  email            :string           not null
#  password_digest  :string           not null
#  session_token    :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  activated        :boolean          default(FALSE)
#  activation_token :string           not null
#
class User < ApplicationRecord
  attr_reader :password

  validates :email, :session_token, :activation_token, presence: true, uniqueness: true
  validates :password_digest, presence: { message: 'Password can\'t be blank' }
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token, :ensure_activation_token

  has_many :notes,
    dependent: :destroy,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: :Note

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def self.generate_token
    SecureRandom.urlsafe_base64(16)
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  def reset_token!(token)
    self.send(token + "=", self.class.generate_token)
    self.save
    self.send(token)
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_token
  end

  def ensure_activation_token
    self.activation_token ||= self.class.generate_token
  end
end
