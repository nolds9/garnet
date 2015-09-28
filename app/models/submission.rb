class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :grader, class_name: "Membership"
  belongs_to :submitter, class_name: "Membership"
end
