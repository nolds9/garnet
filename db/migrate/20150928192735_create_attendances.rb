class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :status
      t.belongs_to :event
      t.belongs_to :membership
      t.timestamps null: false
    end
  end
end
