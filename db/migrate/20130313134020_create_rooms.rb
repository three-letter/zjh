class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :title
      t.integer :state
      t.integer :win
      t.integer :cur_seat_id
      t.integer :score

      t.timestamps
    end
  end
end
