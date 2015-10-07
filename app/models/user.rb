class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :github_id, allow_blank: true, uniqueness: true
  has_many :memberships
  has_many :groups, through: :memberships

  def self.named username
    User.find_by(username: username)
  end

  def self.new_password password
    BCrypt::Password.create(password)
  end

  def password_ok? password
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def save_params params
    return false if self.github_id
    allowed = ["username", "email", "name", "password"]
    params.each do |key, value|
      next if (!allowed.include? key)
      next if !value || value.strip == ""
      if key == "password"
        key = "password_digest"
        value = User.new_password(params["password"])
      end
      self.update_attribute(key, value)
    end
    return self
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

  def minions
    minions = []
    self.groups.each do |group|
      minions.concat(group.memberships.where(is_admin?: false))
    end
    return minions
  end

end
