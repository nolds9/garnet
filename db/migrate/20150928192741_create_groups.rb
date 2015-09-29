class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.string :category
      t.belongs_to :parent, :class_name => "group"
      t.timestamps null: false
    end
  end
end
