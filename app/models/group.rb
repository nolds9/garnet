class Group < ActiveRecord::Base
  has_many :events
  has_many :assignments
  has_many :memberships
  belongs_to :parent, class_name: "Group"
  has_many :subgroups, class_name: "Group", foreign_key: "parent_id"

end
