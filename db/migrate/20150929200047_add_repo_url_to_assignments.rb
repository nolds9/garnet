class AddRepoUrlToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :repo_url, :string
  end
end
