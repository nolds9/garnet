class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :grader, class_name: "Membership"
  belongs_to :submitter, class_name: "Membership"

  def due_date
    self.assignment.due_date.strftime("%a, %m/%d/%y")
  end

  def submit_date
    self.created_at
  end

  def status_english
    case self.status
    when 0
      "missing"
    when 1
      "incomplete"
    when 2
      "complete"
    end
  end
end
