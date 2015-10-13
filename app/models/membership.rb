class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :attendances
  has_many :authored_observations, :class_name => 'Observation', :foreign_key => 'author_id'
  has_many :student_observations, :class_name => 'Observation', :foreign_key => 'observee_id'
  has_many :grades, :class_name => 'Submission', :foreign_key => 'grader_id'
  has_many :submissions, :class_name => 'Submission', :foreign_key => 'submitter_id'

  def self.in_role(name, group_title, is_admin = false)
    if is_admin == "admin"
      is_admin = true
    elsif is_admin == "student"
      is_admin = false
    end
    user = User.find_by(username: name)
    group = Group.find_by(title: group_title)
    membership = Membership.find_by(
      user_id: user.id,
      group_id: group.id,
      is_admin: is_admin
    )
    return membership
  end

  def self.bulk_create(array, group_id, is_admin)
    array.each do |person|
      user = User.find_by(username: person[0])
      if(!user)
        user = User.new(username: person[0], password: person[1])
        user.save!
      end
      user.memberships.create(group_id: group_id, is_admin: is_admin)
    end
  end

  def name
    self.user.username
  end

  def observe name, body, color
    observee = User.find_by(username: name)
    observee_m = self.group.memberships.find_by(user_id: observee.id)
    self.authored_observations.create!(observee_id: observee_m.id, body: body, status: color )
  end

  def last_observation
    self.student_observations.last
  end

  def minions
    group = self.group
    group.memberships.where(is_admin: false)
  end

  def get_subgroups key = nil
    self_result = self.send(key)
    collection = [self_result]
    add_method = "push"
    if self_result.respond_to? "merge"
      collection = self_result
      add_method = "concat"
    end
    self.group.descendants_attr("memberships").each do |membership|
      next if membership.user.id != self.user.id
      collection.send(add_method, membership.send(key))
    end
    return collection
  end

end
