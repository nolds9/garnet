class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.string :status
      t.belongs_to :event_id
      t.belongs_to :membership_id
      t.timestamps null: false
    end
  end
end
