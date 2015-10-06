class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :status
      t.text :student_notes
      t.text :grader_notes
      t.belongs_to :assignment
      t.belongs_to :grader, :class_name => "membership"
      t.belongs_to :submitter, :class_name => "membership"

      t.timestamps null: false
    end
  end
end
