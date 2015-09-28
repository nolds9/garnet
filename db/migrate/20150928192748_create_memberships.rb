class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :group_id
      t.belongs_to :user_id
      t.boolean :is_admin?
      t.timestamps null: false
    end
  end
end
