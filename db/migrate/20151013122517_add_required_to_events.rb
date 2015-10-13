class AddRequiredToEvents < ActiveRecord::Migration
  def change
    add_column :events, :required, :boolean
  end
end
