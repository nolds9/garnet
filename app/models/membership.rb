class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :attendances
  has_many :authored_observations, :class_name => 'Observation', :foreign_key => 'author_id' # as author
  has_many :student_observations, :class_name => 'Observation', :foreign_key => 'observee_id'# as observee
  has_many :graded_submissions, :class_name => 'Submission', :foreign_key => 'grader_id' # as instructor
  has_many :submitted_submissions, :class_name => 'Submission', :foreign_key => 'submitter_id'# as student submitter

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
      is_admin?: is_admin
    )
    return membership
  end

  def self.bulk_create(array, group_id, is_admin)
    array.each do |person|
      user = User.find_by(username: person[0])
      if(!user)
        user = User.sign_up(person[0], person[1])
        user.save
      end
      user.memberships.create(group_id: group_id, is_admin?: is_admin)
    end
  end

  def get_attendance_summary
    attendances = self.attendances

    tardys = attendances.where(status: "tardy").length
    presents = attendances.where(status: "present").length
    absents = attendances.where(status: "absent").length

    return {
      membership_id: self.id,
      tardys: tardys,
      presents: presents,
      absents: absents
    }
  end

  def get_submission_summary
    # summary = {
    #   membership_id: self.id,
    #   incompletes: 0,
    #   missings: 0,
    #   completes: 0
    # }
    # self.submitted_submissions.each do |submission|
    #   if submission.assignment.category != "project"
    #     binding.pry
    #     if submission.status == "incomplete"
    #       summary[:incompletes] += 1
    #     elsif submission.status == "complete"
    #       summary[:completes] += 1
    #     elsif submission.status == "missing"
    #       summary[:missings] += 1
    #     end
    #   end
    # end
    #
    # return summary

    # TODO need a way to filter out projects
    submissions = self.submitted_submissions

    incompletes = submissions.where(status: "incomplete").length
    missings = submissions.where(status: "missing").length
    completes = submissions.where(status: "complete").length

    return summary = {
      membership_id: self.id,
      incompletes: incompletes,
      missings: missings,
      completes: completes
    }

  end

end
