class Group < ActiveRecord::Base
  has_many :events
  has_many :assignments
  has_many :memberships
  has_many :attendances, through: :events
  belongs_to :parent, class_name: "Group"
  has_many :subgroups, class_name: "Group", foreign_key: "parent_id"

  def self.named(group_name)
    Group.find_by(title: group_name)
  end

  def self.bulk_create(groups, parent = nil)
    groups.each do |key, subgroups|
      group = self.create(title: key, parent_id: parent)
      if subgroups.count > 0
        self.bulk_create(subgroups, group.id)
      end
    end
  end

  def all_parents(collection = nil)
    collection = collection || []
    if self.parent
      collection.push(self.parent)
      self.parent.all_parents(collection)
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

  def subgroup_array(collection = nil)
    collection = collection || []
    self.subgroups.each do |subgroup|
      collection.push(subgroup)
      subgroup.subgroup_array(collection)
    end
    return collection
  end

  def get_subgroups key
    collection = []
    if self.send(key).respond_to? "merge"
      add_method = "concat"
    else
      add_method = "push"
    end
    subgroup_array.each do |subgroup|
      result = subgroup.send(key)
      collection.send(add_method, result)
    end
    return collection
  end

end
