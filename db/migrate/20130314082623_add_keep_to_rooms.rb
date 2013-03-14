class AddKeepToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :keep, :string
  end
end
