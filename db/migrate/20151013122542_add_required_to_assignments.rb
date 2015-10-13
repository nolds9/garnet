class AddRequiredToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :required, :boolean
  end
end
