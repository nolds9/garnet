class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validate :is_unique_in_group
  before_save :default_values
  after_create :create_ancestors
  before_destroy :destroy_descendants

  def is_unique_in_group
    if self.group.memberships.exists?(user_id: self.user_id)
      errors[:base].push("A user may have only one membership in a given group.")
    end
  end

  def default_values
    if self.is_admin === nil
      self.is_admin = "false"
    end
  end

  def create_ancestors
    if self.group.parent
      if !self.group.parent.memberships.exists?(user_id: self.user_id)
        self.class.create!(group_id: self.group.parent_id, user_id: self.user_id, is_admin: "false")
      end
    end
  end

  def destroy_descendants
    if self.group.children
      self.group.children.collect{|c| c.memberships}.flatten.each do |child|
        if child.user_id == self.user_id
          child.destroy!
        end
      end
    end
  end

  def self.extract_users array
    array.collect{|m| m.user}.uniq.sort{|a,b| a.name <=> b.name}
  end

  def self.by_user memberships, skip_condition = nil
    collection = {}
    memberships.each do |membership|
      next if skip_condition && membership.send(skip_condition[0]) == skip_condition[1]
      user = membership.user
      if collection.has_key?(user.username) == false
        collection[user.username] = {user: user, memberships: []}
      end
      if !collection[user.username][:memberships].include?(membership)
        collection[user.username][:memberships].push(membership)
      end
    end
    return collection.sort_by{|username, member| member[:user].name}
  end

  def name
    self.user.username
  end

  def observed_by name, body, color
    author = User.find_by(username: name.downcase)
    self.observations.create!(author_id: author.id, body: body, status: color )
  end

  def last_observation
    self.student_observations.last
  end

  def has_descendants?
    children = self.group.children
    descendants = children.select{|c| c.memberships.where(user_id: self.user_id).count > 0}
    return (descendants.count > 0)
  end

end
