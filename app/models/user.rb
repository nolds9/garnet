class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :github_id, allow_blank: true, uniqueness: true
  has_many :memberships
  has_many :groups, through: :memberships
  before_save :before_save
  attr_accessor :password

  def before_save
    self.password_digest = User.new_password(self.password)
  end

  def self.named username
    User.find_by(username: username)
  end

  def self.new_password password
    BCrypt::Password.create(password)
  end

  def password_ok? password
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def is_member_of group, is_admin = false
    group.memberships.exists?(user_id: self.id, is_admin: is_admin)
  end

  def role group_title, is_admin = false
    if is_admin == "admin"
      is_admin = true
    elsif is_admin == "student"
      is_admin = false
    end
    group = Group.find_by(title: group_title)
    return self.memberships.find_by(group_id: group.id, is_admin: is_admin)
  end

  def minions
    minions = []
    self.groups.each do |group|
      minions.concat(group.memberships.where(is_admin: false))
    end
    return minions
  end

end
