class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :category
      t.string :repo_url
      t.string :title
      t.datetime :due_date
      t.belongs_to :group
      t.timestamps null: false
    end
  end
end
