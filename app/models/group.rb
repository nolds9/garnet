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
      if subgroups.length > 0
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
    self_result = self.send(key)
    if self_result.respond_to? "merge"
      add_method = "concat"
      collection = self_result
    else
    add_method = "push"
      collection = [self_result]
    end
    subgroup_array.each do |subgroup|
      result = subgroup.send(key)
      collection.send(add_method, result)
    end
    return collection
  end

  def members where = nil
    memberships = self.get_subgroups("memberships")
    if where
      memberships = memberships.where(where)
    end
    fields = [:attendances, :student_observations, :submissions]
    output = {}
    memberships.each do |membership|
      id = membership.user.id
      fields.each do |field|
        output[id] = {} if !output.has_key?(id)
        output[id][:user] = membership.user if !output[id].has_key?(:user)
        if !output[id].has_key?(field)
          output[id][field] = membership.send(field)
        else
          output[id][field].concat(membership.send(field))
        end
      end
    end
    return output
  end

end
