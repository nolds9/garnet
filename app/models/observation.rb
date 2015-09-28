class Observation < ActiveRecord::Base
  belongs_to :observee, class_name: "Membership"
  belongs_to :author, class_name: "Membership"
end
