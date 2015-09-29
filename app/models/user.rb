class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :github_id, allow_blank: true, uniqueness: true
  has_many :memberships
  has_secure_password

  def self.sign_up username, password
    User.new(
      username: username,
      password_digest: BCrypt::Password.create(password)
    )
  end

  def sign_in password
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
