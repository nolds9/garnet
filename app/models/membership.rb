class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :attendances
  has_many :authored_observations, :class_name => 'Observation', :foreign_key => 'membership_id' # as author
  has_many :student_observations, :class_name => 'Observation', :foreign_key => 'membership_id'# as observee
  has_many :graded_submissions, :class_name => 'Submission', :foreign_key => 'membership_id' # as instructor
  has_many :submitted_submissions, :class_name => 'Submission', :foreign_key => 'membership_id'# as student submitter
end
