class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :github_id, allow_blank: true, uniqueness: true
  has_many :memberships
  has_many :groups, through: :memberships
  has_secure_password

  def self.sign_up username, password
    User.new(
      username: username,
      password_digest: BCrypt::Password.create(password)
    )
  end

  def self.named username
    User.find_by(username: username)
  end

  def role group_title, is_admin = false
    if is_admin == "admin"
      is_admin = true
    elsif is_admin == "student"
      is_admin = false
    end
    group = Group.find_by(title: group_title)
    return self.memberships.find_by(group_id: group.id, is_admin?: is_admin)
  end

  def sign_in password
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def minions
    minions = []
    self.groups.each do |group|
      minions.concat(group.memberships.where(is_admin?: false))
    end
    return minions
  end

end
