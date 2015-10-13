class DangleLessOnMemberships < ActiveRecord::Migration
  def change
    remove_column :attendances, :membership_id, :integer
    add_column :attendances, :user_id, :integer
    add_column :attendances, :admin_id, :integer
    add_column :attendances, :required, :boolean

    remove_column :observations, :observee_id, :integer
    remove_column :observations, :author_id, :integer
    add_column :observations, :user_id, :integer
    add_column :observations, :admin_id, :integer
    add_column :observations, :group_id, :integer

    remove_column :submissions, :grader_id, :integer
    remove_column :submissions, :submitter_id, :integer
    add_column :submissions, :user_id, :integer
    add_column :submissions, :admin_id, :integer
  end
end
