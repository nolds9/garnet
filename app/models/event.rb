class Event < ActiveRecord::Base
  belongs_to :group
  has_many :attendances

  after_create :create_attendances

  def create_attendances
    group = Group.find(self.group_id)

    students = group.memberships.where(is_admin?: false)

    students.each do |student|
      student.attendances.create(event_id: self.id)
    end
  end
end
