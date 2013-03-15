class AddCurPokerToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :cur_poker, :string
  end
end
