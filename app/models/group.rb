class Group < ActiveRecord::Base
  has_many :events
  has_many :assignments
  has_many :memberships 
end
