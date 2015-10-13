class Group < Tree
  has_many :events
  has_many :assignments
  has_many :memberships
  has_many :attendances, through: :events
  belongs_to :parent, class_name: "Group"
  has_many :children, class_name: "Group", foreign_key: "parent_id"

  validates :title, presence: true, format: {with: /[a-zA-Z0-9\-]+/, message: "Only letters, numbers, and hyphens are allowed."}
  validate :has_parent_and_unique_name_among_siblings

  def has_parent_and_unique_name_among_siblings
    if !self.parent
      if self.class.all.count > 0
        errors[:base].push("Each Group has to have a parent group.")
      end
    else
      sibling = self.parent.children.find_by(title: self.title)
      if sibling && sibling.id != self.id
        errors.add(:title, "must be unique among this group's siblings.")
      end
    end
  end

  def self.named(group_name)
    Group.find_by(title: group_name)
  end

  def owners
    self.ancestors_attr("memberships").select{|m| m.is_admin}.collect{|m| m.user}.uniq
  end

  def admins
    self.memberships.where(is_admin: true).collect{|m| m.user}
  end

  def nonadmins
    self.memberships.where(is_admin: false).collect{|m| m.user}
  end

  def subnonadmins
    self.descendants_attr("memberships").select{|m| !m.is_admin}.collect{|m| m.user}.uniq
  end

  def owner_exists? user
    if user.class <= Hash
      username = user["username"]
    else
      username = user.username
    end
    return self.owners.collect{|u| u.username}.include?(username)
  end

  def bulk_create_memberships array, is_admin
    array.each do |child|
      user = User.find_by(username: child[0].downcase)
      if !user
        user = User.create!(username: child[0], name: child.join(" "), password: child[1].downcase)
      end
      self.memberships.create(user_id: user.id, is_admin: is_admin)
    end
  end

end
