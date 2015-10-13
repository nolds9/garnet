class AddPathToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :path, :string
  end
end
