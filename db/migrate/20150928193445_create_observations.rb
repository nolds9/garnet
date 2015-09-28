class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.string :status
      t.text :body
      t.datetime :created_date
      t.belongs_to :membership

      t.timestamps null: false
    end
  end
end
