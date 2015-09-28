class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.datetime :created_date
      t.string :status
      t.text :student_notes
      t.text :grader_notes
      t.belongs_to :assignment
      t.belongs_to :membership
      
      t.timestamps null: false
    end
  end
end
