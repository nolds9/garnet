class Group < ActiveRecord::Base
  has_many :events
  has_many :memberships
  has_many :assignments

  after_create :create_attendances

  def create_attendances
    group = Group.find(self.group_id)

    students = group.memberships.where(is_admin?: false)

    students.each do |student|
      student.attendances.create(group_id: self.id)
    end
  end
end
