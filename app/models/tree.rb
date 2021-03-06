class Tree < ActiveRecord::Base
  self.abstract_class = true
  before_destroy :destroy_descendants

  def ancestors(collection = nil)
    collection = collection || [self]
    if self.parent
      collection.unshift(self.parent)
      self.parent.ancestors(collection)
    end
    return collection
  end

  def descendants(collection = nil)
    collection = collection || [self]
    self.children.each do |child|
      collection.push(child)
      child.descendants(collection)
    end
    return collection
  end

  def descendant_tree
    tree = self.as_json
    children = []
    self.children.each do |child|
      children.push(child.descendant_tree)
    end
    tree[:children] = children
    return tree
  end

  def ancestors_attr key
    collection = []
    collection.concat(self.send(key))
    self.ancestors.each do |ancestor|
      collection.concat(ancestor.send(key))
    end
    return collection.reverse
  end

  def descendants_attr key
    collection = []
    collection.concat(self.send(key))
    self.descendants.each do |descendant|
      collection.concat(descendant.send(key))
    end
    return collection
  end

  def is_descendant? ancestor
    return true if self.id == ancestor.id
    while self.parent
      if self.parent.id == ancestor.id
        return true
      else
        return false
      end
    end
  end

  # submissions group.submissions
  def extract_descendants_from collection, belongs_to
    output = []
    descendants = self.descendants
    collection.each do |record|
      output.push(record) if descendants.include?(record.send(belongs_to))
    end
    return output
  end

  def create_descendants hash, name
    hash.each do |key, subtree|
      child = self.children.new
      child.send("#{name}=", key)
      child.save!
      child.create_descendants(subtree, name)
    end
  end

  def destroy_descendants
    self.class.destroy_all(parent_id: self.id)
  end

end
