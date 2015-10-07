class ChangeColumnNameOnMemberships < ActiveRecord::Migration
  def change
    rename_column :memberships, :is_admin?, :is_admin
  end
end
