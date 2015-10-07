class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :membership

  def date
    self.event.date.strftime("%a, %m/%d/%y")
  end

  def status_english
    case self.status
    when 0
      "absent"
    when 1
      "tardy"
    when 2
      "present"
    end
  end
end
