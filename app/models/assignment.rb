class Assignment < ActiveRecord::Base
  has_many :submissions
  belongs_to :group

  after_create :create_submissions

  def create_submissions
    group = Group.find(self.group_id)

    students = group.memberships.where(is_admin?: false)

    students.each do |student|
      student.submitted_submissions.create(assignment_id: self.id)
    end
  end
end
