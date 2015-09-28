class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :date
      t.belongs_to :group_id
      t.timestamps null: false
    end
  end
end
