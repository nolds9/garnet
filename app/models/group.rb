class Group < ActiveRecord::Base
  has_many :events
  has_many :assignments
  has_many :memberships
  belongs_to :parent, class_name: "Group"
  has_many :subgroups, class_name: "Group", foreign_key: "parent_id"

  def all_subgroups(collection = nil)
    collection = collection || []
    self.subgroups.each do |subgroup|
      collection.push(subgroup)
      subgroup.all_subgroups(collection)
    end
    return collection
  end

  def subgroup_tree
    tree = self.as_json
    subgroups = []
    self.subgroups.each do |subgroup|
      subgroups.push(subgroup.subgroup_tree)
    end
    tree[:subgroups] = subgroups
    return tree
  end

  def self.bulkCreate(groups, parent = nil)
    groups.each do |key, subgroups|
      group = self.create(title: key, parent_id: parent)
      if subgroups.count > 0
        self.bulkCreate(subgroups, group.id)
      end
    end
  end

end
