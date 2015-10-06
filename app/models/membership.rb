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
    group.memberships.where(is_admin?: false)
  end

  def get_attendance_summary
    attendances = self.attendances
    tardys = attendances.where(status: "tardy").length
    presents = attendances.where(status: "present").length
    absents = attendances.where(status: "absent").length
    combined_absences = absents + ( tardys / 4.0 )
    return {
      membership_id: self.id,
      tardys: tardys,
      presents: presents,
      absents: absents,
      combined_absences: combined_absences
    }
  end

  def get_submission_summary
    # TODO need a way to filter out projects
    submissions = self.submitted_submissions

    incompletes = submissions.where(status: "incomplete").length
    missings = submissions.where(status: "missing").length
    completes = submissions.where(status: "complete").length
    total = incompletes + missings + completes
    percentage = ((completes / total.to_f ) * 100).round

    return summary = {
      membership_id: self.id,
      incompletes: incompletes,
      missings: missings,
      completes: completes,
      percentage: percentage
    }
  end

  def color
    percent = get_green_percent
    hue = percent * 1.2 / 360
    rgb = hsl_to_rgb( hue, 1, 0.5 )
    return "rgb(#{rgb[0]}, #{rgb[1]}, #{rgb[2]})"
  end

  def hsl_to_rgb(h, s, l)
    if s == 0
      b = l.to_f
      g = l.to_f
      r = l.to_f
    else
      q = l.to_f < 0.5 ? (l.to_f * (1 + s.to_f)) : (l.to_f + s.to_f - l.to_f * s.to_f)
      p = 2 * l.to_f - q;
      r = hue_to_rgb(p, q, (h + 1/3.0))
      g = hue_to_rgb(p, q, h)
      b = hue_to_rgb(p, q, (h - 1/3.0))
    end
    return [(r * 255).to_i, (g * 255).to_i,(b * 255).to_i ]
  end

  def hue_to_rgb(p,q,t)
    if t < 0
      t += 1
    end
    if t > 1
      t -= 1
    end
    if t < 1/6.0
      return (p + (q-p) * 6 * t)
    end
    if t < 1/2.0
      return q
    end
    if t < 2/3.0
      return (p + (q - p) * (2/3.0 - t) * 6)
    end
      return p
  end

  def get_green_percent
    yellow = self.student_observations.where(status: "yellow").size
    green = self.student_observations.where(status: "green").size
    green += yellow/2.0
    total = self.student_observations.where(status:["yellow","green","red"]).size
    total == 0 ? 0 : (green/total.to_f * 100)
  end

end
