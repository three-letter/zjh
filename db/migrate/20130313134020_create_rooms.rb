class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :title
      t.integer :state, :default => 0
      t.integer :win,   :default => 0
      t.integer :cur_seat_id, :default => 0
      t.integer :score, :default => 0

      t.timestamps
    end
  end
end
