class Observation < ActiveRecord::Base
  belongs_to :observee, class_name: "Membership"
  belongs_to :author, class_name: "Membership"

  def self.statuses
    [["Green", 2], ["Yellow", 1], ["Red", 0]]
  end

end
