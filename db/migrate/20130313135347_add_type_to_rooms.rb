class AddTypeToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :style, :integer
  end
end
