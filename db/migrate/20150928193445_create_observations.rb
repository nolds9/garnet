class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.string :status
      t.text :body
      t.belongs_to :membership

      t.timestamps null: false
    end
  end
end
